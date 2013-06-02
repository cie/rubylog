require "rubylog"

# Read two integers in each line of the input. Write the sum of each pair to the outuput.

module APulsB
  extend Rubylog::Context

  "#{A} #{B}".in{$stdin.readlines}.each do
    puts A.to_i + B.to_i
  end

end
