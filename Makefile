GHDL=ghdl
GFLAGS=
GTKWAVE=gtkwave

BIN=vending_machine_tb
SRCS=vending_machine_tb.vhd vending_machine.vhd
OBJS=$(subst .vhd,.o,$(SRCS))

test: $(OBJS) $(BIN)
	./$(BIN) --vcd=$(BIN).vcd

view:
	$(GTKWAVE) $(BIN).vcd

%: %.o
	$(GHDL) -e $(GFLAGS) $@

%.o: %.vhd
	$(GHDL) -a $(GFLAGS) $<

clean:
	rm -f $(BIN) $(OBJS) work*.cf *.o *.vcd
