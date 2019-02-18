# add subfolders

# add sources
add_test_sources(
    addr_buffer_tb.vhdl                 # 11-bit Address Buffer
    addr_counter_tb.vhdl
    addr_output_module_tb.vhdl          # Address LED Ouput
    control_signal_generator_tb.vhdl    # Control Signal Generator
    data_output_module_tb.vhdl          # Data LED Ouput
    data_pulse_generator_tb.vhdl        # Data LED Ouput
)
