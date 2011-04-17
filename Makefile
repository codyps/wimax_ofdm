
RM = rm -f

TESTS    = randomizer.vvp bitorder.vvp
TEST_OBJ = $(addprefix test/, $(TESTS))
TEST_RUN = $(TEST_OBJ:.vvp=.test)

.PHONY: all
all: test

.PHONY: test_bin
test_bin: $(TEST_OBJ)

.PHONY: .test
test: $(TEST_RUN)

.PHONY: %.test
%.test : %.vvp
	./$<

%.vvp : %.v
	iverilog -I . -o $@ $<

.PHONY: clean
clean:
	$(RM) $(TEST_OBJ)
