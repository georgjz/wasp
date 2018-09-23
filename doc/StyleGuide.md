# Style Guide
This is a general style guide for VHDL files in this project.

## 1. Naming Convention

### 1.1 General
1. Each line must contain only one VHDL statement
2. Each line must be indented properly (4 spaces)
3. No TAB characters should be used for indentation
4. All source code should be written in lower-case, except for constant declarations
5. Snake-case is allowed

### 1.2 Signals, Variables, and Constants
1. Signal names should not exceed 24 characters
2. Active-low signals should be suffixed with `_n`
3. Intermediate signals define source and destination blocks
4. The same rules are valid for variables
5. Constants should be written in upper-case

### 1.3 Entities and Generics
1. The function of each port should be commented
2. Ports can only have one of two types: `in` or `out`
3. Ports should be ordered by function
4. Ports should only be of `std_logic` or `std_logic_vector` type

### 1.4 Data Organisation
1. VHDL source files should use `.vhdl` as extension
2. Use suffixes: `_tb` for test benches, `_cf` for configurations, and `_pk` for packages
3. Each file starts with a header:
```
-------------------------------------------------------------------------------
--
-- unit name: <full name> (<shortname / entity name>)
-- author: <author name> (<email>)
--
-- description: <file content, behaviour, purpose, special usage notes...>
-- <further description>
--
-- dependencies: <entity name>, ...
--
-------------------------------------------------------------------------------
-- TODO: <next thing to do>
-- <another thing to do>
--
-------------------------------------------------------------------------------
```
4. All entities must have their own self-containing test bench
