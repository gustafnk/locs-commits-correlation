## Synopsis

The core reason behind this project is to test the hypothesis that there is a correlation between the LOC of a file and the number of commits to that file. 

The results so far: see below.

First, run "bundle install" to install dependencies.

Example usage:

    $ git clone https://github.com/sinatra/sinatra.git repos/sinatra
    $ ./run.sh repos/sinatra "lib/**/*.rb"
      [...depending on the size and history of the repo, this might take a looong time]

Now, open 
    http://localhost:4567
in a web browser.

The R² value is also found in the console output.

There is a possibility for you to test your "glob" with test_glob.sh:

    $ ./test_glob.sh repos/sinatra "lib/**/*.rb"

R² values
---
    ./run.sh repos/sinatra "lib/**/*.rb": 0.81
    ./run.sh repos/padrino/ "**/*.rb": 0.52
    ./run.sh repos/lime "**/*.go": 0.63
    ./run.sh repos/jquery/ "**/src/*.js": 0.48
    ./run.sh repos/nancy "**/*.cs": 0.17

## Motivation

I want to know whether the correlation hypothesis between lines of code and number of commits is correct.


## Installation

    bundle install

## Contributors/contact

Put an issue/question on this repo or contact me at [@gustaf_nk](https://twitter.com/gustaf_nk)

## License

This project is published under the MIT licence.
