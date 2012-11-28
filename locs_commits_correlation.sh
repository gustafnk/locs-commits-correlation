bash ./locs_and_commits.sh "$1" "$2" > tmp

DIRECTORY="out"

# name=basename "$1" # TODO Learn more about basename
# name+=".html"

if [ ! -d "$DIRECTORY" ]; then
    mkdir "$DIRECTORY"
fi

node locsAndCommits > "$DIRECTORY/result.html"
rm tmp