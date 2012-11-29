
#######################
# Example usage:
# $ ./locs_commits_correlation.sh ../path/to/repo/root/ "relative/path/to/your/files/*.js"
#
# With "real parameters"
# $ ./locs_commits_correlation.sh ../jenkins/ "*.java": 0.456447887030814 (2m)
#######################


current_path=$PWD;
cd "$1"
project_name=${PWD##*/};
cd "$current_path"

echo
echo " - Gathering metrics for project named '$project_name'..."
echo

dataset_directory="datasets"
if [ ! -d "$dataset_directory" ]; then
    mkdir "$dataset_directory"
fi

bash ./locs_and_commits.sh "$1" "$2" > "$dataset_directory/$project_name"
cp "$dataset_directory/$project_name" tmp

output_directory="out"
if [ ! -d "$output_directory" ]; then
    mkdir "$output_directory"
fi

node locsAndCommits > "$output_directory/$project_name.html"
cp "r_squared.tmp" "$output_directory/$project_name.txt"
rm "tmp"
rm "r_squared.tmp"