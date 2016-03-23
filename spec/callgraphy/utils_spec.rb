require "callgraphy/utils"

module Callgraphy
  RSpec.describe Utils do
    describe "#pascal_case" do
      it "works" do
        expect(Utils.pascal_case("some_name")).to eq("SomeName")
      end
    end
  end
end
