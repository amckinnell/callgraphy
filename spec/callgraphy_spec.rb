require "spec_helper"

module Callgraphy
  RSpec.describe Callgraphy do
    let(:registry) { instance_double(Registry) }

    describe ".draw" do
      it "invokes collaborators" do
        expect(Definition).to receive(:register).and_return(registry)
        expect(CallGraph).to receive(:draw).with("target", "output", registry)

        Callgraphy.draw(target: "target", output_directory: "output")
      end

      it "default the output directory to the current directory" do
        expect(Definition).to receive(:register).and_return(registry)
        expect(CallGraph).to receive(:draw).with("target", ".", registry)

        Callgraphy.draw(target: "target")
      end
    end

    it "has a version number" do
      expect(Callgraphy::VERSION).not_to be_nil
    end
  end
end
