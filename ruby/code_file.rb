class CodeFile
 
  attr_reader :number_of_commits, :loc, :path, :loc_per_commits, :commits_per_loc

  def initialize(path, number_of_commits, loc)
    @path = path
    @number_of_commits = number_of_commits.to_i
    @loc = loc.to_i

    @loc_per_commits = @loc.fdiv(@number_of_commits).round(2)
    @commits_per_loc = @number_of_commits.fdiv(@loc).round(2)
  end

  def to_s
    "#{@number_of_commits} #{@loc} #{@path}"
  end
end


