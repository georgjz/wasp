# add subfolders
add_subdirectory(chips/)
add_subdirectory(modules/)

# add sources
add_sources(
    simple_wasp.vhdl
    wasp_records_pkg.vhdl           # Data LED Ouput
)
