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
