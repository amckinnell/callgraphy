# Callgraphy

[![Gem Version](https://badge.fury.io/rb/callgraphy.svg)](https://badge.fury.io/rb/callgraphy)
[![GitHub license](https://img.shields.io/github/license/mashape/apistatus.svg)]()

Callgraphy is a simple tool that provides a DSL for creating call tree graphs for a target class.

## Installation

Add this line to your application's Gemfile:

    gem "callgraphy"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install callgraphy

## Usage

    require "callgraphy"

    Callgraphy.draw target: "rule_service" do
      methods_to_graph :public,
        :generate_lot_code => [:generate_lot_code_fragments, :reference_value_for],
        :interpret_mfg_date_from_lot => [:earliest_date, :interpret_from]

      methods_to_graph :private,
        :earliest_date => [:validate_length],
        :generate_lot_code_fragments => [],
        :interpret_from => [:validate_length],
        :reference_value_for => [],
        :validate_length => []

      constants_to_graph :callers,
        :code_generation_service => [:generate_lot_code, :interpret_mfg_date_from_lot]

      constants_to_graph :dependencies,
        :earliest_date => [:earliest_date_interpreter]
    end

![RuleService Call Graph](https://github.com/amckinnell/callgraphy/blob/master/sample/rule_service.png)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version,
update the version number in `version.rb`, and then run `bundle exec rake release`,
which will create a git tag for the version, push git commits and tags, and push the `.gem` file
to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amckinnell/callgraphy.
This project is intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
