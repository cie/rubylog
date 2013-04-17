require "rubylog"
extend Rubylog::Context

predicate_for String, "FILE.found_at(PATH)"

FILE.found_at(DIR).if F.
