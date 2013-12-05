module FlakyProxy
  class RuleSet
    class Builder
      attr_reader :rules

      def initialize(ruleset, &blk)
        @ruleset = ruleset
        @rules = []
      end

      def match(criteria, &blk)
        @ruleset.rules << Rule.new(criteria, &blk)
      end
    end

    def self.build(text=nil, &blk)
      ruleset = self.new 
      Builder.new(ruleset).instance_eval(text, &blk)
      ruleset
    end

    attr_accessor :rules

    def initialize
      @rules = []
      @default_rule = Rule.new { pass }
    end

    def match(request)
      @rules.detect { |rule| rule.match?(request) } || @default_rule
    end
  end
end
