# add subfolders
add_subdirectory(chips/)

# add sources
add_test_sources(
    addr_output_module_tb.vhdl # Address LED Ouput
    input_panel_tb.vhdl
)
