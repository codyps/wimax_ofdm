module ifft
	#(parameter num_width = 16,
	  in_ct = 200,
  	  in_width = num_width * in_ct * 2,
	  out_ct = 256,
  	  out_width = num_width * out_ct * 2)
	(input reset, clk,
	input [in_width - 1:0] in_blk,
	input in_blk_valid,
	output [out_width - 1:0] out_blk,
	output out_blk_valid);

endmodule


