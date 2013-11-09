
class CodeFile
  def initialize(path, number_of_commits, loc)
    @path = path
    @number_of_commits = number_of_commits
    @loc = loc  
  end

  def to_s
    "#{@number_of_commits} #{@loc} #{@path}"
  end
end

# Gather
paths = Dir.glob("**/*")

code_files = paths.select {|path| !FileTest.directory?(path) }.map do |file_path|
  number_of_commits = `git log --follow -p --pretty=format: --name-only #{file_path} | \
   grep -v '^$' | wc -l`.to_i

   if number_of_commits > 0 
     lines_of_code = `wc -l #{file_path}`.split(" ")[0]
     CodeFile.new(file_path, number_of_commits, lines_of_code) 
   end
end.select {|code_file| not code_file.nil? }

code_files.each do |code_file|
  puts code_file.to_s
end
