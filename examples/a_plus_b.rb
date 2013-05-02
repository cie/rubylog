require "rubylog"
extend Rubylog::Context

"#{A} #{B}".in{$stdin.readlines}.each do
  puts A.to_i + B.to_i
end
