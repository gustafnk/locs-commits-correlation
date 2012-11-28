(cd "$1"; git log --pretty=format: --name-only -- "$2" | sort | uniq -c | sort -rg | while read n file; do
    cd "$1";
	loc=`wc -l "$file" || echo "0"`;
	echo "$file $n $loc"
done)