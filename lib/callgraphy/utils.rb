module Callgraphy
  # Utility methods.
  #
  module Utils
    def self.pascal_case(snake_case)
      snake_case.split("_").map(&:capitalize).join
    end
  end
end
