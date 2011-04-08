module interleaver
	#(parameter blk_size = 384)
	(input reset, clk,
	input [blk_size-1:0] in_blk,
	input in_blk_valid,
	input [2:0] rate_id,
	input [2:0] subchan_ct,
	output reg [blk_size-1:0] out_blk,
	output reg out_blk_valid);

	always @ (reset) if (reset == 0) begin
		
	end

	always @ (posedge clk) begin

	end

	always @ (negedge clk) begin

	end

endmodule

