
/* Max is set to QPSK's largest */
module blk_conv
	#(
	parameter in_blk_size = 1,
	parameter max_out_blk_size = 384
	)(
	input reset, clk,
	input in_valid,
	input [in_blk_size-1:0] in_data,
	input [16:0] out_blk_size,
	output [max_out_blk_size-1:0] out_blk
	);

endmodule
