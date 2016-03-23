module Callgraphy
  # Exposes a DSL to generate call graphs for a target class.
  #
  class Definition
    attr_reader :registry

    def self.define(target_class_name, &block)
      Definition.new(Registry.new(target_class_name)).tap do |definition|
        definition.instance_eval(&block)
      end
    end

    def initialize(registry)
      @registry = registry
    end

    def graph(output_directory: ".")
      CallGraph.new(graphviz_instance, output_directory, registry).graph
    end

    def methods_to_graph(method_scope, calls)
      validate_scope(method_scope, :public, :private)
      register_methods_to_graph(method_scope, calls)
    end

    def constants_to_graph(constant_scope, calls)
      validate_scope(constant_scope, :callers, :dependencies)
      register_constants_to_graph(constant_scope, calls)
    end

    private

    def graphviz_instance
      GraphViz.new(:G, type: :digraph, labelloc: "b", label:
        "Target class is #{Utils.pascal_case(registry.target_class_name)}")
    end

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
