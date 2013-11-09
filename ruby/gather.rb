
files = Dir.glob("**/*")

files.select {|file| !FileTest.directory?(file) }.each do |file|
  number_of_commits = `git log --follow -p --pretty=format: --name-only #{file} | \
   grep -v '^$' | wc -l`.to_i

  if number_of_commits > 0 
    lines_of_code = `wc -l #{file}`.split(" ")[0]
    puts "#{number_of_commits} #{lines_of_code} #{file}"
  end
end


