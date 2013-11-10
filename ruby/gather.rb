require 'linefit'

class CodeFile
 
  attr_reader :number_of_commits, :loc

  def initialize(path, number_of_commits, loc)
    @path = path
    @number_of_commits = number_of_commits.to_i
    @loc = loc.to_i
  end

  def to_s
    "#{@number_of_commits} #{@loc} #{@path}"
  end
end

def get_correlation_status(r_squared)

  rounded = r_squared.round(1)

  if rounded >= 0.7
    "Correlation";
  elsif 0.5 <= rounded && rounded < 0.7
    "Correlation-ish"
  else 
    "No correlation"
  end
end


# Gather
paths = Dir.glob("**/*.js")

puts "Reading commit history...."
code_files = paths.select {|path| !FileTest.directory?(path) }.map do |file_path|
  number_of_commits = `git log --follow -p --pretty=format: --name-only #{file_path} | \
   grep -v '^$' | wc -l`.to_i

   if number_of_commits > 0 
     lines_of_code = `wc -l #{file_path}`.split(" ")[0]
     CodeFile.new(file_path, number_of_commits, lines_of_code) 
   end
end.select {|code_file| not code_file.nil? }

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

puts "----------------------------"
puts "y = k*x + m, where\nk = #{slope}\nm = #{intercept}"
puts "------"
puts "R^2: #{r_squared}"
puts "Correlation status*: #{get_correlation_status(r_squared)}"
puts "  * Should be taken with a grain of salt"
puts "----------------------------"
