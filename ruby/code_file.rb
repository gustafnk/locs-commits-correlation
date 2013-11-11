class CodeFile
 
  attr_reader :number_of_commits, :loc, :path

  def initialize(path, number_of_commits, loc)
    @path = path
    @number_of_commits = number_of_commits.to_i
    @loc = loc.to_i
  end

  def to_s
    "#{@number_of_commits} #{@loc} #{@path}"
  end
end


