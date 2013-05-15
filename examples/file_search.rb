require "rubylog"
extend Rubylog::Context

[true,false].each do |b|
  puts "Files which #{b ? 'have' : 'do not have'} spec:"

  "lib/#{X}.rb".file_in("lib/**").each do
    if b == "spec/#{X}_spec.rb".file_in?("spec/**")
      puts X
    end
  end

  puts

end

