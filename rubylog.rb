# rubylog.rb -- Prolog workalike for Ruby
# github.com/cie/rubylog

module Rubylog
  class << self

    def use *modules
      modules.each do |m|
        m.send :include, Rubylog::Term
      end
    end

    def use_vars
      def Object.const_missing k
        Rubylog::Variable.new k
      end
    end

  end


  module Term
    def method_missing

    end
  end


  class Variable
    def initialize name
      @name = name
    end
    def inspect
      @name
    end
  end


end
