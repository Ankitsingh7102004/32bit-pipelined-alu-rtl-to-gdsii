create_clock -name clk -period 20.000 [get_ports clk]
set_input_delay 1.0 -clock clk [get_ports {rst valid_in a b opcode}]
set_output_delay 1.0 -clock clk [get_ports {valid_out result}]
