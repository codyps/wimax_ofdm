module aopm_unit(
	input clk, reset,

	output xs,
	output and_out);
endmodule


module aopm
	#(
	parameter m = 8,
	parameter x_init = 0,
	)(
	input clk, reset,

	input b, c,
	output a
	);

	

endmodule

/* Design from: "An efficient reconfigurable multiplier architecture
* for Galois field GF(2^m)" (Kistos et al.)
* After m clock cycles the right multiplication result
* is stored in the LFSR. */
module m2
	#(
	parameter m = 8, /* in GF(2^m) */
	parameter a = 0, /* one of the multiplicands */
	parameter p = 0, /* the primitive poly */
	)(
	input clk, reset,

	input b, /* the second multiplicand */
	output [m-1:0] c /* multiplied output */
	);

	reg b_cpy;
	reg [m-1:0] lfsr;

	wire [m-1:0] partial_products = {m{b_cpy}} & a;
	wire [m-1:0] feed_back        = {m{lfsr[m-1]} & p;
	wire [m-1:0] lfsr_next        = feed_back ^ partial_products ^ {lfsr[m-1:1], 0};

	always @(posedge clk or posedge reset) if (reset) begin
		b_cpy = 0;
	end else begin
		b_cpy = b;
	end

	always @(negedge clk or posedge reset) if (reset) begin
		lfsr = {m{1'b0}};
	end else begin
		lfsr = lfsr_next;
	end

	assign c = lfsr;

endmodule
