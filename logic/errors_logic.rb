theory do
  functor_for String, :happy, :has

  # syntax error
  check { begin "John".happy.if; rescue Rubylog::SyntaxError; true else false end }
  check { begin "John".happy.if!; rescue Rubylog::SyntaxError; true else false end }
  check { begin "John".happy.unless; rescue Rubylog::SyntaxError; true else false end }

end
