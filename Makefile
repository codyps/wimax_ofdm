
RM = rm -f

TESTS    = bitorder.vvp rand.vvp cc.vvp
TEST_OBJ = $(addprefix t/, $(TESTS))
TEST_RUN = $(TEST_OBJ:.vvp=.test)


.PHONY: all
all: test_bin

.PHONY: test_bin
test_bin: $(TEST_OBJ)

.PHONY: .test
test: $(TEST_RUN)

%.vvp : %.v $(wildcard test_vect/*.v)
	iverilog -Wall -I . -o $@ $<

.PHONY: %.test
%.test : %.vvp 
	./$<

.PHONY: clean
clean:
	$(RM) $(TEST_OBJ)

t/rand.vvp: rand.v func/gen_rand_iv.v

t/cc.vvp: fec.v
