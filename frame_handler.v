module frame_handler(
	input reset, clk,
	input in_bits,
	input in_bits_clk,
	input in_valid,
	output burst_reset,
	output burst_bits,
	output burst_valid,
	output [3:0] frame_num,
	output [3:0] iuc,
	output [6:0] subchan_data,
	output [2:0] rate_id
);

endmodule
