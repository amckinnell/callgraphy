require "callgraphy/registry"

module Callgraphy
  RSpec.describe Registry do
    subject(:registry) { Registry.new("target_class") }

    it "registers the target class name" do
      expect(registry).to have_attributes(
        target_class_name: "target_class"
      )
    end

    it "registers public methods" do
      registry.register_method(:public, :m_1)
      registry.register_method(:public, :m_2)

      expect(registry).to have_attributes(
        all_public_methods: %w(m_1 m_2),
        all_private_methods: []
      )
    end

    it "registers private methods" do
      registry.register_method(:private, :m_1)

      expect(registry).to have_attributes(
        all_public_methods: [],
        all_private_methods: ["m_1"]
      )
    end

    it "handles registration of duplicate methods" do
      registry.register_method(:private, :m_1)
      registry.register_method(:private, :m_1)

      expect(registry).to have_attributes(
        all_public_methods: [],
        all_private_methods: ["m_1"]
      )
    end

    it "sorts registered methods" do
      registry.register_method(:public, :m_2)
      registry.register_method(:public, :m_4)
      registry.register_method(:public, :m_1)
      registry.register_method(:public, :m_3)

      expect(subject).to have_attributes(
        all_public_methods: ["m_1", "m_2", "m_3", "m_4"],
        all_private_methods: []
      )
    end

    it "registers calls" do
      registry.register_call(:m_1, :m_2)

      expect(subject).to have_attributes(
        all_calls: [%w(m_1 m_2)]
      )
    end

    it "registers callers constants" do
      registry.register_constant(:callers, :c_1)

      expect(subject).to have_attributes(
        all_callers: ["c_1"]
      )
    end

    it "registers dependencies constants" do
      registry.register_constant(:dependencies, :c_2)

      expect(subject).to have_attributes(
        all_dependencies: ["c_2"]
      )
    end
  end
end
