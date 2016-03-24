require "ruby-graphviz"

module Callgraphy
  # Knows how to graph the target class call graph given the specified registry.
  #
  class CallGraph
    NODE_OPTIONS = {
      public: { style: "filled", fillcolor: "palegreen" },
      private: {},
      callers: { style: "filled", fillcolor: "lightblue" },
      dependencies: { style: "filled", fillcolor: "lightcoral" }
    }

    attr_reader :registry

    def self.draw(target, output_directory, registry)
      new(target, output_directory, registry).graph
    end

    def initialize(target, output_directory, registry)
      @target = target
      @output_directory = output_directory
      @registry = registry

      @nodes = {}
    end

    def graph
      add_methods
      add_constants
      add_calls

      generate_graph
    end

    private

    def add_methods
      registry.all_public_methods.each { |name| add_node(name, NODE_OPTIONS[:public]) }
      registry.all_private_methods.each { |name| add_node(name, NODE_OPTIONS[:private]) }
    end

    def add_constants
      registry.all_callers.each { |name| add_node(name, add_constant_label(name, NODE_OPTIONS[:callers])) }
      registry.all_dependencies.each { |name| add_node(name, add_constant_label(name, NODE_OPTIONS[:dependencies])) }
    end

    def add_node(node_name, node_opts)
      @nodes[node_name] = graphviz.add_nodes(node_name, node_opts.dup)
    end

    def add_constant_label(constant_name, node_opts)
      node_opts.merge(label: Utils.pascal_case(constant_name))
    end

    def add_calls
      registry.all_calls.each { |caller, callee| add_call(caller, callee) }
    end

    def add_call(caller, callee)
      graphviz.add_edges(@nodes.fetch(caller), @nodes.fetch(callee))
    end

    def generate_graph
      graphviz.output(png: graph_filename)
    end

    def graph_filename
      File.join(@output_directory, "#{@target}.png")
    end

    def graphviz
      @graphviz ||= GraphViz.new(:G, type: :digraph, labelloc: "b", label:
        "Target class is #{Utils.pascal_case(@target)}")
    end
  end
end
