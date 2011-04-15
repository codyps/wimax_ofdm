
RM = rm -f

TESTS    = randomizer
TEST_OBJ = $(addprefix test/, $(TESTS))

.PHONY: test
test: $(TEST_OBJ)


% : %.v
	iverilog -I . -o $@ $<

.PHONY: clean
clean:
	$(RM) $(TEST_OBJ)
