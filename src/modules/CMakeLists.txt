# add subfolders
# add_subdirectory(chips/)

# add sources
add_sources(
    addr_output_module.vhdl         # Address LED Ouput
    addr_buffer.vhdl
    control_signal_generator.vhdl   # Control signals
    data_output_module.vhdl         # Data LED Ouput
)
