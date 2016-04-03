module Callgraphy
  # Exposes a DSL to describe call graphs for a target class.
  #
  class Definition
    attr_reader :registry

    def self.register(&block)
      definition = Definition.new(Registry.new)
      definition.instance_eval(&block)
      definition.registry
    end

    def initialize(registry)
      @registry = registry
    end

    def methods_to_graph(method_scope, calls = {})
      validate_scope(method_scope, :public, :private)
      register_methods_to_graph(method_scope, calls)
    end

    def constants_to_graph(constant_scope, calls = {})
      validate_scope(constant_scope, :callers, :dependencies)
      register_constants_to_graph(constant_scope, calls)
    end

    private

    def register_methods_to_graph(method_scope, calls)
      register_calls(calls) do |caller, _callees|
        register_method(method_scope, caller)
      end
    end

    def register_constants_to_graph(constant_scope, calls)
      register_calls(calls) do |caller, callees|
        register_constants(constant_scope, caller, callees)
      end
    end

    def register_constants(constant_scope, caller, callees)
      constants = constant_scope == :callers ? caller : callees
      register_constant(constant_scope, constants)
    end

    def register_calls(calls)
      calls.each do |caller, callees|
        yield(caller, callees)
        register_each_call(caller, callees)
      end
    end

    def register_each_call(caller, callees)
      callees.each { |callee| registry.register_call(caller, callee) }
    end

    def register_method(method_scope, caller)
      registry.register_method(method_scope, caller)
    end

    def register_constant(constant_scope, constants)
      Array(constants).each { |constant| registry.register_constant(constant_scope, constant) }
    end

    def validate_scope(scope, *valid_scopes)
      raise "Invalid scope: #{scope}" unless valid_scopes.include?(scope)
    end
  end
end
