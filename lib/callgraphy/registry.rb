module Callgraphy
  # Records the information that describes a call graph.
  #
  class Registry
    def initialize
      @registry = { public: [], private: [], callers: [], dependencies: [], calls: [] }
    end

    def register_method(scope, caller)
      @registry.fetch(scope).push(caller.to_s)
    end
    alias register_constant register_method

    def register_call(caller, callee)
      @registry.fetch(:calls).push([caller.to_s, callee.to_s])
    end

    def all_public_methods
      normalized :public
    end

    def all_private_methods
      normalized :private
    end

    def all_calls
      normalized :calls
    end

    def all_callers
      normalized :callers
    end

    def all_dependencies
      normalized :dependencies
    end

    private

    def normalized(category)
      @registry.fetch(category).sort.uniq
    end
  end
end
