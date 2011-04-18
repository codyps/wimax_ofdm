
RM = rm -f

TESTS    = bitorder.vvp rand_parm.vvp
TEST_OBJ = $(addprefix test/, $(TESTS))
TEST_RUN = $(TEST_OBJ:.vvp=.test)


test/rand_parm.vvp: randomizer.v func/gen_rand_iv.v



.PHONY: all
all: test_bin

.PHONY: test_bin
test_bin: $(TEST_OBJ)

.PHONY: .test
test: $(TEST_RUN)

%.vvp : %.v
	iverilog -Wall -I . -o $@ $<

.PHONY: %.test
%.test : %.vvp
	./$<

.PHONY: clean
clean:
	$(RM) $(TEST_OBJ)
