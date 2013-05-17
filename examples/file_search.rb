require "rubylog"
extend Rubylog::Context

# Outputs which source files have and which source files do not have a test.

[true,false].each do |b|
  puts "Files which #{b ? 'have' : 'do not have'} spec:"

  "lib/#{X}.rb".file_in("lib/**").each do
    if b == "spec/#{X}_spec.rb".file_in?("spec/**")
      puts X
    end
  end

  puts

end

