
// TODO Add some tests

var jade = require('jade'),
    fs = require('fs'),
    $_ = require('underscore');

var data = fs.readFileSync("tmp", 'utf8');
var lines = data.split("\n");

if (!data)
    throw {
        name: "No data found", 
        message: "Something went wrong... No data in file or file not found."
    };

// TODO Extract function to separate file
function leastSquares(xs, ys) {
    
    $_.sum = function(numbers){
        return $_.reduce(numbers, function(memo, number){
            return memo + number;
        }, 0);
    };

    var xsSum = $_.sum(xs);
    var ysSum = $_.sum(ys);

    var xsSquaredSum = $_.sum(xs.map(function(x){
        return x*x;
    }));

    var ysSquaredSum = $_.sum(ys.map(function(y){
        return y*y;
    }));

    var valuePairs = $_.zip(xs, ys);
    var xsTimesYsSum = $_.sum(valuePairs.map(function(pair){
        return pair[0]*pair[1];
    }));

    var count = valuePairs.length;
    
    // Calculate m and b for the equation y = x * m + b 
    var slope = (count*xsTimesYsSum - xsSum*ysSum) / (count*xsSquaredSum - xsSum*xsSum);
    var intercept = (ysSum/count) - (slope*xsSum)/count;
    var rSquared = Math.pow((count*xsTimesYsSum - xsSum*ysSum)/Math.sqrt((count*xsSquaredSum-xsSum*xsSum)*(count*ysSquaredSum-ysSum*ysSum)),2);

    return {
        slope: slope,
        intercept: intercept,
        rSquared: rSquared,
        toString: function(){
            return "y = k*x + m, where\n\n" + "k = " + this.slope + "\nm = " + this.intercept;
        },
        getValidity: function(){
            var rounded = Math.round(this.rSquared*10)/10;
            if (rounded >= 0.7)
                return "valid";
            else if(0.5 <= rounded && rounded < 0.7) {
                return "warning";
            }
            else {
                return "invalid";
            }
        }
    };
}

var metricsNotSorted =
    $_.chain(lines)
        .tail()
        .initial()
        .map(function(line){
            return line.split(" "); // TODO Use regex instead to avoid silly stuff below
        }).filter(function(tuple){
            return $_.last(tuple) !== "0";
        }).map(function(tuple){
            return {
                commits: parseInt($_.first($_.tail(tuple))),
                loc: parseInt($_.last($_.initial(tuple)))
            };
        }).value();

var metrics = $_.sortBy(metricsNotSorted, "loc");

var locs = $_.map(metrics, function(metric){return metric.loc;});
var commits = $_.map(metrics, function(metric){return metric.commits;});

var linearRegression = leastSquares(locs, commits);
fs.writeFile("r_squared.tmp", JSON.stringify({r2: linearRegression.rSquared}));

var template = fs.readFileSync("template.jade", 'utf8');
var template_loc = fs.readFileSync("template_loc.jade", 'utf8');
var template_commits = fs.readFileSync("template_commits.jade", 'utf8');
var template_rsquared = fs.readFileSync("template_rsquared.jade", 'utf8');

var fn = jade.compile(template);
var fn_loc = jade.compile(template_loc);
var fn_commits = jade.compile(template_commits);
var fn_rsquared = jade.compile(template_rsquared)

var sumForProperty = function(property){
    return metrics.map(function(item){
        return item[property];
    }).reduce(function(m,n){
        return m+n;
    });
};
var locSum = sumForProperty("loc");
var commitSum = sumForProperty("commits");  

var writePercentForProperty = function(property, sum){
    metrics.forEach(function(item){ 
        var num = item[property]/sum;
        item[property + "Percent"] = Math.round(num*10000)/10000;
    });
};
writePercentForProperty("loc", locSum);
writePercentForProperty("commits", commitSum);

var writeRatio = function(property, sum){
    metrics.forEach(function(item){ 
        var num = item.loc/item.commits;
        
        item["ratio"] = Math.round(num*10000)/10000;
    });
};
writeRatio();

var filesPercent = metrics.map(function(){
    return 1/metrics.length;
});

var returnAccumulatedSum = function(list){
    var sum = 0;
    return list.map(function(item){
        sum += item; 
        return sum;
    });
};

var filesPercentAccSum = returnAccumulatedSum(filesPercent)

var reverse = function(a){
    var temp = [];
    var len = a.length;
    for (var i = (len -1); i != 0; i--)
        temp.push(a[i]);

    return temp;
};

var sortByLocs = metrics;
var sortByCommits = $_.sortBy(metrics, "commits");
var sortByReverseLocs = reverse(sortByLocs);

var writeAccumulatedSumForProperty = function(list, property){
    var sum = 0;
    list.forEach(function(item){
        sum += item[property]; 
        item[property + "AccSum"] = Math.round(sum*100)/100;
    });
};

writeAccumulatedSumForProperty(sortByReverseLocs, "locPercent");
writeAccumulatedSumForProperty(sortByReverseLocs, "commitsPercent");


var str = 
    fn_rsquared(linearRegression) + "\n\n" +
    fn_loc({metrics: sortByLocs}) + "\n\n" +
    fn_commits({metrics: sortByCommits}) + "\n\n" +
    fn({metrics: sortByReverseLocs});

var htmlTemplate = fs.readFileSync("result_template.html", 'utf8');
var result = htmlTemplate.replace("<!-- placeholder for tables -->", str);

console.log(result);