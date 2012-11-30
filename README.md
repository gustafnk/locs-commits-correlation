
The core reason behind this project is to test the hypothesis that there is a correlation between the LOC of a file and the number of commits to that file.

TODO: Write more text here... :)

Example usage:
$ cd ..
$ git clone https://github.com/jenkinsci/jenkins.git
$ cd locs-commits-correlation
$ ./locs_commits_correlation.sh ../jenkins/ "*.java"
  [...wait two minutes, lots of warnings appear...]
$ start out/jenkins.html   # or just open it in an open web browser


R^2 values
---
 ./locs_commits_correlation.sh ../jenkins/ "*.java": 0.456447887030814 (2m)
 ./locs_commits_correlation.sh ../rails/ "*.rb": 0.3384583256446627 (2m13s)
 ./locs_commits_correlation.sh ../linux/ "*.c": 0.2475822925417388 (14m52s)
 ./locs_commits_correlation.sh ../redis/ "*.c": 0.3402266622296573 (6s)
 ./locs_commits_correlation.sh ../django/ "*.py": 0.4406735561150325 (1m4s)
 ./locs_commits_correlation.sh ../mono/ "*.cs": NaN, ouch... (15m56s) 