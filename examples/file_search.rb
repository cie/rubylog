# Outputs which source files have and which source files do not have a test.
#

predicate_for String, ".libfile .specfile"

L.libfile.if "lib/#{L}.rb".file_in("lib/**")
L.specfile.if "spec/#{L}_spec.rb".file_in("spec/**")

puts "Libs which have spec:"
L.libfile.and(L.specfile).each { puts L }
puts
puts "Libs which do not have spec:"
L.libfile.and(L.specfile.false).each { puts L }
puts
puts "Specs which do not have lib:"
L.specfile.and(L.libfile.false).each { puts L }
puts
