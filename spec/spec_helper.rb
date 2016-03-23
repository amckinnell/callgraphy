# Right at the top so we don't miss any opportunities to track coverage.
require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "callgraphy"
