module burst_handler(
	input reset, clk,
	input [3:0] iuc, bsid, frame_num,
	input burst_in_bits, burst_in_valid,
	output [14:0] rand_iv,
	output rand_reload,
	output burst_out_bits,
	output burst_out_valid,
	input [5:0] subchan_data_in,
	output [5:0] subchan_data_out,
	output [3:0] subchan_ct,
	input [2:0] rate_id_in,
	output [2:0] rate_id_out);

endmodule
