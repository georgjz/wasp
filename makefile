GHDL=ghdl
GHDLFLAGS=
MODULES=\
	sn74ahc573.o \
	sn74ahc573_tb


test: $(MODULES)
		./sn74ahc573_tb --vcd=make.vcd
        # ./full_adder_testbench --vcd=full_adder_testbench.vcd
        # ./carry_ripple_adder_testbench --vcd=carry_ripple_adder_testbench.vcd
        # ./alu_testbench --vcd=alu_testbench.vcd

# Binary depends on the object file
%: obj/%.o
	$(GHDL) -e $(GHDLFLAGS) $@

# Object file depends on source
obj/%.o: src/%.vhd
	$(GHDL) -a $(GHDLFLAGS) $<

# clean:
	# echo "Cleaning up..."
	# rm -f *.o *_testbench full_adder carry_ripple_adder work*.cf e*.lst
