require "callgraphy/utils"

module Callgraphy
  RSpec.describe Utils do
    describe "#pascal_case" do
      it "converts case" do
        expect(Utils.pascal_case("some_name")).to eq("SomeName")
      end
    end
  end
end
