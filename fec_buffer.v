module fec_buffer
	#(parameter blk_width = 768)
	(
	input reset, clk,
	input fec_out_bits,
	input fec_out_valid,
	output [blk_width - 1:0],
	output blk_valid,
	input advance);

endmodule
