require "callgraphy/call_graph"
require "callgraphy/definition"
require "callgraphy/registry"
require "callgraphy/utils"
require "callgraphy/version"

# Provides a DSL for creating call graphs for a target class.
#
module Callgraphy
  def self.draw(target:, output_directory: ".", &block)
    CallGraph.draw(target, output_directory, Definition.register(&block))
  end
end
