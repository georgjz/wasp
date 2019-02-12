# add subfolders
add_subdirectory(chips/)
add_subdirectory(modules/)

# add sources
add_test_sources(
    simple_wasp_tb.vhdl
    # addr_output_module_tb.vhdl      # Address LED Ouput
    # data_output_module_tb.vhdl      # Data LED Ouput
    # syncer_tb.vhdl                  # Signal-clock syncer
)
