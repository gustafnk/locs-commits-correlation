require 'linefit'
require_relative 'code_file'
require_relative 'correlation_status_helper'
require_relative 'server'


def get_commit_history(glob)
  paths = Dir.glob(glob)

  puts
  puts "Found files:"
  puts paths

  puts
  puts "Reading commit history.... (This will take a while, grab a cup of coffee)"

  files = paths.select {|path| !FileTest.directory?(path) }

  count = files.length
  code_files = files.map.with_index do |file_path, index|
    puts "File number #{index+1} of #{count}"
    number_of_commits = `git log --follow -p --pretty=format: --name-only #{file_path} | \
   grep -v '^$' | wc -l`.to_i

   if number_of_commits > 0 
     lines_of_code = `wc -l #{file_path}`.split(" ")[0]
     CodeFile.new(file_path, number_of_commits, lines_of_code) 
   end
  end.select {|code_file| not code_file.nil? }

  code_files
end


def get_correlation(code_files)
  puts "Calculating..."

  loc_list = code_files.map do |code_file|
    code_file.loc
  end

  number_of_commits_list = code_files.map do |code_file|
    code_file.number_of_commits
  end

  lineFit = LineFit.new
  lineFit.setData(loc_list, number_of_commits_list)
  intercept, slope = lineFit.coefficients
  r_squared = lineFit.rSquared

  [intercept.round(2), slope.round(2), r_squared.round(2)]
end


def print_correlation(intercept, slope, r_squared)
  puts
  puts "----------------------------"
  puts "y = k*x + m, where\nk = #{slope}\nm = #{intercept}"
  puts "------"
  puts "R^2: #{r_squared}"
  puts "Correlation status*: #{get_correlation_status(r_squared)}"
  puts "  * Should be taken with a grain of salt"
  puts "----------------------------"
end

glob = ARGV[1] # TODO Error handling
code_files = get_commit_history(glob)
intercept, slope, r_squared = get_correlation(code_files)

print_correlation(intercept, slope, r_squared)
start_server(code_files, intercept, slope, r_squared)
