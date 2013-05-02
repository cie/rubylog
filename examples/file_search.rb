require "rubylog"
extend Rubylog::Context

predicate_for String, "FILE.found_in(DIR)"

FILE.found_in(DIR).if FILE.file_in(DIR)
FILE.found_in(DIR).if DIR2[thats_not =~ /\/\./].dir_in(DIR).and FILE.found_in(DIR2)

"lib/#{X}.rb".found_in("lib").and "lib/#{X}"
"#{X}/spec/#{S}_spec.rb".found_in("spec").each do
  puts S
end


