
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


class Statistics

  attr_reader :slope, :intercept, :r_squared

  def initialize(slope, intercept, r_squared)
    @slope = slope
    @intercept = intercept
    @r_squared = r_squared
  end

  def to_s
    "y = k*x + m, where\n" + "k = " + @slope.to_s + "\nm = " + @intercept.to_s
  end
end

def get_validity

  rounded = r_squared.round(1)

  if rounded >= 0.7
    "valid";
  elsif 0.5 <= rounded && rounded < 0.7
    "warning"
  else 
    "invalid"
  end
end

def sum(numbers)
  numbers.inject {|sum, x| sum + x}
end

def squared_sum(numbers)
  sum(numbers.map {|number| number * number })
end

def least_squares(xs, ys)

  xs_sum = sum(xs);
  ys_sum = sum(ys);

  xs_squared_sum = squared_sum(xs)
  ys_squared_sum = squared_sum(ys)

  value_pairs = xs.zip(ys);
  xs_times_ys_sum = sum(value_pairs.map {|pair| pair[0] * pair[1] })

  count = value_pairs.length

  # Calculate m and b for the equation y = x * m + b 
  slope = (count*xs_times_ys_sum - xs_sum*ys_sum).fdiv(count*xs_squared_sum - xs_sum**2)
  intercept = ys_sum.fdiv(count) - slope*xs_sum.fdiv(count)

  # Calculate r_squared
  nominator = count*xs_times_ys_sum - xs_sum*ys_sum
  denominator = Math.sqrt((count*xs_squared_sum -xs_sum**2)*(count*ys_squared_sum-ys_sum**2))
  r_squared = nominator.fdiv(denominator) ** 2

  Statistics.new(slope, intercept, r_squared)
end


# Gather
paths = Dir.glob("**/*.js")

puts "Reading files...."
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

statistics = least_squares(loc_list, number_of_commits_list)

puts "----------------------------"
puts statistics
puts "------"
puts "R^2: #{statistics.r_squared}"
puts "----------------------------"
