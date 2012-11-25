git log --pretty=format: --name-only -- *.cs| sort | uniq -c | sort -rg | while read n file; do
	count=`wc -l "$file" || echo "0"`
	echo "$file $n $count"
done