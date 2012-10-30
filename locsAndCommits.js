
var metrics = [
	{loc: 1, commits: 2},
	{loc: 2, commits: 4},
	{loc: 3, commits: 6},
	{loc: 4, commits: 8},
	{loc: 5, commits: 10},
	{loc: 6, commits: 12},
	{loc: 7, commits: 14},
	{loc: 8, commits: 16},
	{loc: 9, commits: 18},
	{loc: 10, commits: 20}
];

// TODO filter out loc === 0 or commits === 0

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
metrics.forEach(function(item){
	console.log(
		"LOC: ", item.loc, "; Commits: ", item.commits, 
		"; LOCPercent: ", item.locPercent, "; LOCPercentAccSum: ", item.locPercentAccSum,
		"; CommitPercent: ", item.commitsPercent, "; CommitPercentAccSum: ", item.commitsPercentAccSum
	);
});

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

console.log();
console.log("LOC sum:", locSum);
console.log("Commit sum:", commitSum);

//console.log(filesPercentAccSum);