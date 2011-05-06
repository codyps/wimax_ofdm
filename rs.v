
/* 2^8 gfa mult for p(x) = x^8 + x^4 + x^3 + x^2 + 1,
 * bit serial methodology */
module gfa_mult
#(parameter w = 1)(
	input  reset, clk,
	input  [w-1:0] bit_in,
	output [w-1:0] bit_out
);

	reg [w-1:0] b;

	always @(posedge clk or posedge reset) begin
		if(reset) begin
			b = {w{1'b0}};
		end else begin
		end
	end

	always @(negedge clk or posedge reset) begin
		if (reset) begin
		end else begin
		end
	end

endmodule

module rs_b
	#(
	parameter w = 1,
	parameter m = 8,
	parameter logm = /* $clog2(m) */ 3,
	parameter T = 8,
	parameter log2T = /* $clog2(2*T) */ 4
	)(
	input reset, clk,

	input in_bits,
	input in_valid,

	output reg out_bits,
	output reg out_valid
	);

	reg [1:0] state;
	localparam S_INIT = 0; /* shifting in the first 8 bits,
				no valid output */
	localparam S_IMED = 1; /* in the middle, output continually valid */
	localparam S_SHCK = 2; /* shift out the check bits, no input
				accepted */
	localparam S_INVL = 3; /* invalid and unused (only a place holder) */

	wire [m-1:0] m_out [2*T-1:0];
	reg  [m-1:0] m_reg [2*T-1:0];
	reg  [m-1:0] x     [2*T-1:0];

	wire vin  = in_bits & in_valid;
	wire vclk = clk     & in_valid;

	/* in_valid on posedge of current clock */
	reg was_valid;

	/* expected to overflow on exceeding m.
	* XXX: probably assumed to be 8 at some point, be careful */
	reg [logm-1:0] ct_8;

	/* expected to overflow upon exceeding 2T */
	reg [log2T-1:0] ct_2T;

	generate
		genvar i;
		for(i = 0; i < 2*T; i = i + 1) begin : mutls
			gf_mult #(.a(g[i])) gm (reset, vclk, vin, m_out[i]);
		end
	endgenerate

	wire [m-1:0] xn [2*T-2:0];

	generate
		genvar i;
		for(i = 0; i < 2*T - 1; i = i + 1) begin : xnext
			assign xn[i] = x[i+1] ^ m_out[i];
		end
	endgenerate

	always @(posedge clk or posedge reset) if (reset) begin : pos_reset
		integer i;
		for(i = 0; i < 2*T; i = i + 1) begin
			m_reg[i] = 0;
		end

		was_valid = 0;
	end else begin : pos_run
		integer i;
		for(i = 0; i < 2*T; i = i + 1) begin
			m_reg[i] = m_out[i];
		end

		was_valid = in_valid;
	end

	/* FIXME: in state S_IMED, gaps in the input (the valid_in line
	 * temporarily going low) are not allowed. Need to keep track of
	 * how far along in the block we are to allow gaps. */
	always @(negedge clk or posedge reset) if (reset) begin
		out_bits = 0;
		out_valid = 0;
		state = S_INIT;
		ct_8 = 0;
		ct_2T = 0;
	end else begin

		if (state == S_IMED) begin
			/* FIXME: does not allow gaps in input, see above. */
			if (~was_valid) begin
				state = S_SHCK;
			end
			out_valid = 1;
			out_bits = x[0][m-1];
			x[0] = { x[0][m-2:0], 0 };
		end

		if (state == S_SHCK) begin
			ct_2T = ct_2T + 1;

			out_valid = 1;
			out_bits = x[0][m-1];
			x[0] = { x[0][m-2:0], 0 };
			if (~ct_2T) begin : back_to_init
				state = S_INIT;
				out_valid = 0;

				integer i;
				for(i = 0; i < 2*T; i = i + 1) begin
					x[i] = 0;
				end
			end
		end

		if (was_valid || (state == S_SHCK)) begin
			ct_8 = ct_8 + 1;
			if (~ct_8) begin : shift_x

				/* the first 8 bits have been shifted in, advance
				* state */
				if (state == S_INIT) begin
					state = S_IMED;
				end

				/* Needed as X is an array */
				integer i;
				for(i = 0; i < 2*T; i = i + 1) begin
					x[i] = xn[i];
				end
			end
		end
	end

endmodule


/* reed solomon encoding */
module rs_a
	#(
	parameter w = 1
	)(
	input reset, clk,

	input [w-1:0] in_bits,
	input in_valid,

	output reg [w-1:0] out_bits,
	output reg out_valid
	);

	localparam T = 8;
	//localparam log_T = 3;
	localparam log_2T = 4;

	/* The Reed-Solomon encoding shall be derived from a systematic RS (N
	 * = 255, K = 239, T = 8) code using GF(2^8),
	 *
	 * Can be viewed as multiplication by the generator:
	 *  c = g · i
	 *  where c x = a valid code word (a poly)
	 *  	  g x = the generator polynomial
	 *  	  i x = the information poly.
	 *
	 * Also: remainder from division:
	 */

	/* Field generator polynomial
	 * p(x) = x^8 + x^4 + x^3 + x^2 + 1
	 */

	/* Code generator polynomial
	 * g(x) = (x + λ^0)(x + λ^1)(x + λ^2)…(x + λ^(2T – 1)), λ = 02HE
	 */

	/* Galios field operations:
	 * addition: xor
	 * multiplication: multiplication modulo the generator polynomial
	 */


	reg in_data;
	reg in_data_valid;

	/* when ~in_data_valid, the number of shifts out remaining */
	reg start_T;
	reg [log_2T-1:0] shift_ct;

	/* 2T flip flops each with width 'w' */
	reg [w-1:0] b [2*T-1:0];

	/* Outputs of the multipliers */
	wire [w-1:0] gm_out [2*T-1:0];
	reg  [w-1:0] gm_in;

	generate
		genvar i;
		for (i = 0; i < 2*T; i = i + 1) begin : mult_gen
			gfa_mult #(.w(w)) mult (reset, clk, gm_in, gm_out[i]);
		end
	endgenerate

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			in_data <= 0;
			in_data_valid <= 0;
			start_T <= 0;

		end else begin
			in_data <= in_bits;
			if (in_data_valid && ~in_valid) begin
				in_data_valid <= in_valid;
				start_T <= 1;
			end else begin
				in_data_valid <= in_valid;
				start_T <= 0;
			end
		end
	end

	always @(negedge clk or posedge reset) begin
		if (reset) begin
			out_bits  <= 0;
			out_valid <= 0;

			gm_in <= 0;

			begin : reset_ff
				integer i;
				for (i = 0; i < 2*T; i = i + 1) begin
					b[i] <= {w{1'b0}};
				end
			end
			shift_ct <= 0;
		end else begin

			if (start_T) begin
				shift_ct <= {log_2T{1'b1}} - 1;

				gm_in <= 0;
				shift_ct <= shift_ct - 1;
				out_bits <= b[2*T-1];
				out_valid <= 1;

			end else if (in_data_valid) begin
				gm_in <= in_data ^ b[2*T-1];

				out_bits <= in_data;
				out_valid <= 1;

			end else if (shift_ct) begin
				gm_in <= 0;
				shift_ct <= shift_ct - 1;
				out_bits <= b[2*T-1];
				out_valid <= 1;
			end else begin
				gm_in <= 0;
				out_bits <= 0;
				out_valid <= 0;
			end

			begin : shift_ff
				integer i;
				for (i = 0; i < 2*T - 1; i = i + 1) begin
					b[i+1] = gm_out[i] ^ b[i];
				end
			end
		end
	end

endmodule
