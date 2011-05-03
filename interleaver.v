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
	parameter ex_blk_size  = 1, /* the external block size */
	)(
	input reset, clk,
	input [blk_size-1:0] in_blk,
	input in_blk_valid,
	input [rate_w-1:0] rate_id,
	input [subct_w-1:0] subchan_ct,
	output reg [blk_size-1:0] out_blk,
	output reg out_blk_valid
	);

	localparam max_internal_buf_sz = 1152;

	localparam mod_ct = 4;
	localparam sub_ct = 5;
	localparam blk_szs [mod_ct-1:0][sub_ct-1:0] = {
		{192,	96,	48,	24,	12},
		{384,	192,	96,	48,	24},
		{768,	384,	192,	96,	48},
		{1152,	576,	288,	144,	72}
	};

	/* @output_buffer - data which is being shifted out. */
	/* @input_buffer  - data which is being shifted in. */
	reg [max_internal_buf_sz-1:0] output_buffer, input_buffer;

	/* @i_blk - input to the current ir_base module */
	reg [max_internal_buf_sz-1:0] i_blk;

	/* @in_ct - number of external blocks which have been read into internal
	 * buffers */
	/* @out_ct - number of external blocks which need to be written out 
	 */
	reg [$clog2(blk_size)-1:0] in_ct, out_ct;

	/* @set_output - when 1, read the output from the ir_base into the
	 * output_buffer */
	reg set_output;

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
			.in_blk(i_blk),
			.out_blk(o_blk[mod_n][sub_n])
			);
	end
	end
	endgenerate

	always @(posedge clk or posedge reset)
	if (reset) begin
		in_ct  = 0;
		i_blk = 0;
		set_output = 0;
		input_buffer = 0;
	end else begin
		if (valid_in) begin
			/* store the current input data into the internal
			 * buffer */
			/* XXX: this multiplication always has an equivalent
			 * shift, is the synthesizer smart enough? */
			input_buffer[ex_blk_sz * in_ct :+ ex_blk_sz] = in_blk;
			in_ct = in_ct + 1;

			if (in_ct >= cur_internal_blk_sz) begin
				/* setup the current ir_base so that on the
				 * negedge we will have the interleaved results */
				/* XXX: as in_blk_sz is non-constant, this is
				 * not valid verilog. */
				i_blk = input_buffer[ex_blk_sz * in_ct :- in_blk_sz];
				set_output = 1;
			end else begin
				set_output = 0;
			end
		end

	end

	always @(negedge clk or posedge reset)
	if (reset) begin
		out_blk = 0;
		out_blk_valid = 0;
		out_ct = 0;
	end else begin
		if (out_ct) begin
			/* shift out data */
			out_ct = out_ct - 1;
			out_blk = outpuf_buffer[ex_blk_sz * out_ct :- ex_blk_sz];
		end

		if (set_output) begin
			out_ct = in_blk_sz;
			outpuf_buffer[0 :+ in_blk_sz] = o_blk[rate_id][subchan_ct];
		end
	end


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

