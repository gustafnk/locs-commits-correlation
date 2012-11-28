# Example usage:
# $ ./locs_commits_correlation.sh ../path/to/repo/root/ "relative/path/to/your/files/*.js"

# With "real parameters"
# $ ./locs_commits_correlation.sh ../myRepo/ "js/modules/*.js"

bash ./locs_and_commits.sh "$1" "$2" > tmp

DIRECTORY="out"

# name=basename "$1" # TODO Learn more about basename
# name+=".html"

if [ ! -d "$DIRECTORY" ]; then
    mkdir "$DIRECTORY"
fi

node locsAndCommits > "$DIRECTORY/result.html"
rm tmp