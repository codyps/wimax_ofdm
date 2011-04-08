/* FEC is composed of 2 portions, reed solomon and convolution code,
* applied in that order. */

module fec(
	input reset, clk
	input in_bits,
	input in_valid,
	output out_bits,
	output out_valid,
	input [3:0] rate_id
	/* FIXME: I think this need more inputs */
	);

	always @(reset) begin
		
	end

	always @ (posedge clk) begin
		
	end

	always @ (negedge clk) begin

	end

endmodule

/* convolution code */
module cc_enc(
	/* ?? */
	);

endmodule

/* reed solomon encoding */
module rs_enc(
	);

endmodule
