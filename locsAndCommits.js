var jade = require('jade'),
	fs = require('fs'),
	$_ = require('underscore');

var data = fs.readFileSync("tmp.txt", 'utf8');
var lines = data.split("\n");

var metrics =
	$_.chain(lines)
		.tail()
		.initial()
		.map(function(line){
			return line.split(" "); // TODO Use regex instead to avoid silly stuff below
		}).map(function(tuple){
			return {
				commits: $_.first($_.tail(tuple)),
				loc: $_.last($_.initial(tuple))
			};
		}).value();

var template = fs.readFileSync("template.jade", 'utf8');
var fn = jade.compile(template);

// TODO Add graphics/charts
// TODO Add some tests

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
		item[property + "Percent"] = item[property]/sum;
	});
};
writePercentForProperty("loc", locSum);
writePercentForProperty("commits", commitSum);

var writeAccumulatedSumForProperty = function(property){
	var sum = 0;
	metrics.forEach(function(item){
		sum += item[property]; 
		item[property + "AccSum"] = sum;
	});
};

writeAccumulatedSumForProperty("locPercent");
writeAccumulatedSumForProperty("commitsPercent");

// Print the result matrix
/*
metrics.forEach(function(item){
	console.log(
		"LOC: ", item.loc, "; Commits: ", item.commits, 
		"; LOCPercent: ", item.locPercent, "; LOCPercentAccSum: ", item.locPercentAccSum,
		"; CommitPercent: ", item.commitsPercent, "; CommitPercentAccSum: ", item.commitsPercentAccSum
	);
});
*/

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

//console.log();
//console.log("LOC sum:", locSum);
//console.log("Commit sum:", commitSum);

//console.log(filesPercentAccSum);

var str = fn({metrics: metrics});
console.log(str);
