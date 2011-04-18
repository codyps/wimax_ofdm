
RM = rm -f

TESTS    = bitorder.vvp rand.vvp cc.vvp
TEST_OBJ = $(addprefix test/, $(TESTS))
TEST_RUN = $(TEST_OBJ:.vvp=.test)


test/rand.vvp: rand.v func/gen_rand_iv.v

test/cc.vvp: fec.v



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
