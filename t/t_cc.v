`include "t/vect/1.v"
`include "fec.v"

module test();

	reg reset, clk, valid_in, cur_in;
	wire [1:0] z;
	wire valid_out;

	cc_base x1(reset, clk, valid_in, cur_in, z, valid_out);


endmodule
