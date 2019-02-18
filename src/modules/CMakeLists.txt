# add subfolders
# add_subdirectory(chips/)

# add sources
add_sources(
    addr_buffer.vhdl
    addr_counter.vhdl
    addr_output_module.vhdl         # Address LED Ouput
    control_signal_generator.vhdl   # Control signals
    data_output_module.vhdl         # Data LED Ouput
    pulse_generator_positive.vhdl   # One-clock pulse generator
    pulse_generator_negative.vhdl   # One-clock pulse generator
)
