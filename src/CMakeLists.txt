# add subfolders
add_subdirectory(chips/)
# add_subdirectory(modules/)

# add sources
add_sources(
    addr_output_module.vhdl         # Address LED Ouput
    # addr_counter_submodule.vhdl     # Address LED Ouput
    # addr_counter.vhdl               # Address LED Ouput
    data_output_module.vhdl         # Data LED Ouput
    # switch_input_module.vhdl        # Data LED Ouput
    # wasp_records_pkg.vhdl           # Data LED Ouput
    syncer.vhdl                     # signal-clock syncer
)
