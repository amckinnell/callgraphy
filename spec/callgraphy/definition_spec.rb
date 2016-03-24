require "ruby-graphviz"

require "callgraphy/definition"

module Callgraphy
  RSpec.describe Definition do
    describe "#define" do
      it "works" do
        registry = Definition.register do
          methods_to_graph :public, m_1: [:m_2]
          methods_to_graph :private, m_2: []

          constants_to_graph :callers, c_1: [:m_1]
          constants_to_graph :dependencies, m_2: [:c_2]
        end

        expect(registry).to have_attributes(
          all_public_methods: ["m_1"],
          all_private_methods: ["m_2"],
          all_callers: ["c_1"],
          all_dependencies: ["c_2"],
          all_calls: [["c_1", "m_1"], ["m_1", "m_2"], ["m_2", "c_2"]]
        )
      end

      it "fails for an unknown method scope" do
        expect do
          Definition.register do
            methods_to_graph :bad_scope, m_1: []
          end
        end.to raise_error(RuntimeError, /Invalid scope: bad_scope/)
      end

      it "fails for an unknown constant scope" do
        expect do
          Definition.register do
            constants_to_graph :bad_scope, c_1: [:m_1]
          end
        end.to raise_error(RuntimeError, /Invalid scope: bad_scope/)
      end
    end
  end
end
