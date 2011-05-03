`include "param.v"

/* Ncbps = blk_size
 * Mod    16   8   4   2   1
 * BPSK   192  96  48  24  12
 * QPSK   384  192 96  48  24
 * 16-QAM 768  384 192 96  48
 * 64-QAM 1152 576 288 144 72
 */

module blk_sz_decoder
	#(
	parameter rate_w  = p_rate_id.w,
	parameter subct_w = p_subchan_ct.w
	)(
	input [rate_w-1:0]  rate,
	input [subct_w-1:0] subchan,
	output
	);

endmodule

module interleaver
	#(
	parameter rate_w  = p_rate_id.w,
	parameter subct_w = p_subchan_ct.w,
	parameter blk_sz  = 1,
	)(
	input reset, clk,
	input [blk_size-1:0] in_blk,
	input in_blk_valid,
	input [rate_w-1:0] rate_id,
	input [subct_w-1:0] subchan_ct,
	output [blk_size-1:0] out_blk,
	output out_blk_valid
	);

	reg [$clog2(blk_sz)-1:0] blk_sz

	localparam mod_ct = 4;
	localparam sub_ct = 5;
	localparam blk_szs [mod_ct-1:0][sub_ct-1:0] = {
		{192,	96,	48,	24,	12},
		{384,	192,	96,	48,	24},
		{768,	384,	192,	96,	48},
		{1152,	576,	288,	144,	72}
	};

	/* presently, only QPSK is supported */
	wire o_valid [mod_ct-1:0][sub_ct-1:0];
	wire [blk_size-1:0] o_blk [mod_ct-1:0][sub_ct-1:0];

	generate
	genvar mod_n, sub_n;
	for (mod_n = 0; mod_n < mod_ct; mod_n = mod_n + 1) begin : ir_mod
	for (sub_n = 0; sub_n < sub_ct; sub_n = sub_n + 1) begin : ir_sub
		ir_base r
			#(
			.blk_size(blk_szs[mod_n][sub_n]),
			.subchan_ct(sub_n)
		  	)(
			.in_blk(in_blk),
			.out_blk(o_blk[mod_n][sub_n])
			);
	end
	end
	endgenerate

endmodule


/* Takes a particular block of data, and outputs the interleaved version of
 * that block */
module ir_base
	#(
	parameter blk_size = 384,
	parameter subch_ct = 16
	)(
	input [blk_size-1:0] in_blk,
	output reg [blk_size-1:0] out_blk,
	);
	
	/*
	 * Let Ncpc be the number of coded bits per subcarrier,
	 * i.e., 1, 2, 4 or 6 for BPSK, QPSK, 16-QAM, or 64-
	 * QAM, respectively. Let s = ceil(Ncpc/2).
	 *
	 * The first permutation is defined by:
	 * m_k = ( N_cbps ⁄ 12 ) ⋅ k mod12 + floor ( k ⁄ 12 ).
	 * 	k = 0, 1, ..., N_cbps – 1
	 *
	 * The second permutation is defined by Equation (26).
	 * j_k = s ⋅ floor ( m_k ⁄ s ) + ( m_k + N_cbps –
	 *           floor ( 12 ⋅ m_k ⁄ N_cbps ) ) mod ( s )
	 * 	k = 0, 1, ..., N_cbps – 1
	 */

	/* FIXME: Only works for QPSK and BPSK, need to use Ncpc? */
	generate
		genvar k;
		for (k = 0; k < blk_size; k = k + 1) begin: g1
			assign out_blk[k] <= in_blk[(k % 12) * blk_size / 12 + floor(k / 12)];	
		end
	endgenerate
endmodule

