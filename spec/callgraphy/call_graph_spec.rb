require "callgraphy/call_graph"

module Callgraphy
  RSpec.describe CallGraph do
    let(:graphviz) { GraphViz.new(:G, type: :digraph) }
    let(:registry) { instance_double(Registry, target_class_name: "target_class") }

    subject(:call_graph) { CallGraph.new(graphviz, "output_directory", registry) }

    it "generates a graph" do
      configure_registry(
        public_methods: ["m_1"],
        private_methods: ["m_2", "m_3"],
        callers: ["c_1"],
        dependencies: ["c_2"],
        calls: [["m_1", "m_2"], ["m_2", "m_3"], ["c_1", "m_1"], ["m_3", "c_2"]]
      )

      expect_graphviz_to_add_nodes_for(
        ["m_1", CallGraph::PUBLIC_OPTIONS],
        ["m_2", CallGraph::PRIVATE_OPTIONS],
        ["m_3", CallGraph::PRIVATE_OPTIONS],
        ["c_1", CallGraph::CALLERS_OPTIONS.merge(label: "C1")],
        ["c_2", CallGraph::DEPENDENCIES_OPTIONS.merge(label: "C2")]
      )
      expect(graphviz).to receive(:add_edges).exactly(4).and_call_original
      expect(graphviz).to receive(:output).with(png: "output_directory/target_class.png")

      call_graph.graph
    end

    private

    def configure_registry(public_methods:, private_methods:, callers:, dependencies:, calls:)
      allow(registry).to receive(:all_public_methods).and_return(public_methods)
      allow(registry).to receive(:all_private_methods).and_return(private_methods)
      allow(registry).to receive(:all_calls).and_return(calls)
      allow(registry).to receive(:all_callers).and_return(callers)
      allow(registry).to receive(:all_dependencies).and_return(dependencies)
    end

    def expect_graphviz_to_add_nodes_for(*add_nodes_arguments)
      add_nodes_arguments.each do |node_name, node_opts|
        expect(graphviz).to receive(:add_nodes).with(node_name, node_opts).and_call_original
      end
    end
  end
end
