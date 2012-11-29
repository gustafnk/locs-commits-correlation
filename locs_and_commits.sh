current_path=$PWD
cd "$1"; 
git log --pretty=format: --name-only -- "$2" | 
    sort | uniq -c | sort -rg | while read n file; 
    do
    	loc=`wc -l "$file" || echo "0"`;
    	echo "$file $n $loc"
    done
cd "$current_path"