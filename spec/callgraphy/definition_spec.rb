require "ruby-graphviz"

require "callgraphy/definition"

module Callgraphy
  RSpec.describe Definition do
    describe "#define" do
      let(:graph) { instance_double(Graph) }

      it "works" do
        expect_registry_to_receive(
          [:register_method, :public, :m_1],
          [:register_method, :private, :m_2],
          [:register_constant, :callers, :c_1],
          [:register_constant, :dependencies, :c_2],
          [:register_call, :m_1, :m_2],
          [:register_call, :m_2, :c_2],
          [:register_call, :c_1, :m_1]
        )
        expect_graphviz_to_have(label: "Target class is TargetClass")
        expect_graph_to_have(output_directory: "dir")

        Definition.define "target_class" do
          methods_to_graph :public, m_1: [:m_2]
          methods_to_graph :private, m_2: []

          constants_to_graph :callers, c_1: [:m_1]
          constants_to_graph :dependencies, m_2: [:c_2]
        end.graph(output_directory: "dir")
      end

      it "configures Graph with default output directory" do
        expect_registry_to_receive([:register_method, :public, :m_1])
        expect_graphviz_to_have(label: "Target class is ClassToGraph")
        expect_graph_to_have(output_directory: ".")

        Definition.define "class_to_graph" do
          methods_to_graph :public, m_1: []
        end.graph
      end

      it "fails for an unknown method scope" do
        expect do
          Definition.define "target_class" do
            methods_to_graph :bad_scope, m_1: []
          end
        end.to raise_error(RuntimeError, /Invalid scope: bad_scope/)
      end

      it "fails for an unknown constant scope" do
        expect do
          Definition.define "target_class" do
            constants_to_graph :bad_scope, c_1: [:m_1]
          end
        end.to raise_error(RuntimeError, /Invalid scope: bad_scope/)
      end

      def expect_graphviz_to_have(label:)
        expect(GraphViz).to receive(:new).with(:G, type: :digraph, labelloc: "b", label: label).and_call_original
      end

      def expect_graph_to_have(output_directory:)
        expect(Graph).to receive(:new)
          .with(instance_of(GraphViz), output_directory, instance_of(Registry))
          .and_return(graph)
        expect(graph).to receive(:graph)
      end

      def expect_registry_to_receive(*expected_registry_calls)
        expected_registry_calls.each do |method, caller, callee|
          expect_any_instance_of(Registry).to receive(method).with(caller, callee)
        end
      end
    end
  end
end
