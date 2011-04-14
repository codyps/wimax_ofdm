module interleaver
	#(parameter blk_size = 384)
	(input reset, clk,
	input [blk_size-1:0] in_blk,
	input in_blk_valid,
	input [2:0] rate_id,
	input [2:0] subchan_ct,
	output reg [blk_size-1:0] out_blk,
	output reg out_blk_valid);

/*
 * The first permutation is defined by:
 * m_k = ( N_cbps ⁄ 12 ) ⋅ k mod12 + floor ( k ⁄ 12 ).
 * 	k = 0, 1, ..., N_cbps – 1
 * The second permutation is defined by Equation (26).
 * j_k = s ⋅ floor ( m_k ⁄ s ) + ( m_k + N_cbps – floor ( 12 ⋅ m_k ⁄ N_cbps ) ) mod ( s )
 * 	k = 0, 1, ..., N_cbps – 1
 */


	always @ (reset) if (reset == 0) begin
		
	end

	always @ (posedge clk) begin

	end

	always @ (negedge clk) begin

	end

endmodule

