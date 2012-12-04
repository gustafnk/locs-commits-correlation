The core reason behind this project is to test the hypothesis that there is a correlation between the LOC of a file and the number of commits to that file. The method for finding the number of commits for a file could be better, since it's based on file name. Thus, renaming the file resets the number.

The results so far: I have seen a project (not open sourced) that have a R² value of 0.7, which (for some) indicates correlation. However, many of the popular projects here on github have R² values between 0.2 and 0.5, indicating some correlation but not having LOC as the largest influencing factor.

Run "npm install jade" to install dependencies.

Example usage:

    $ cd ..
    $ git clone https://github.com/jenkinsci/jenkins.git
    $ cd locs-commits-correlation
    $ ./locs_commits_correlation.sh ../jenkins/ "*.java"
      [...wait two minutes, lots of warnings appear...]
    $ start out/jenkins.html   # or just open it in an open web browser

Example results are found in the folder example_output/ (clone the repo and open one of the files in a browser).

R² values
---
    ./locs_commits_correlation.sh ../jenkins/ "*.java": 0.456 (2m)
    ./locs_commits_correlation.sh ../rails/ "*.rb": 0.338 (2m13s)
    ./locs_commits_correlation.sh ../redis/ "*.c": 0.340 (6s)
    ./locs_commits_correlation.sh ../django/ "*.py": 0.441 (1m4s)
    ./locs_commits_correlation.sh ../linux/ "*.c": 0.248 (14m52s)
    ./locs_commits_correlation.sh ../mono/ "*.cs": NaN, ouch... (15m56s) 

TODO: Add missing packages.json file.