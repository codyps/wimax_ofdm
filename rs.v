
/* 2^8 gfa mult for p(x) = x^8 + x^4 + x^3 + x^2 + 1,
 * bit serial methodology */
module gfa_mult(
	input  reset, clk,
	input  bit_in,
	output bit_out
);

	localparam w = 8;

	reg [w-1:0] b;

	always @(posedge clk or posedge reset) begin
		if(reset) begin
			b = {w{0}};
		end else begin
		end
	end

	always @(negedge clk or posedge reset) begin
		if (reset) begin
		end else begin
		end
	end

endmodule


/* reed solomon encoding */
module rs_enc(
	input reset, clk

	input in_bits,
	input in_valid,

	output reg out_bits,
	output reg out_valid
	);

	localparam w = 8;
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
	wire [w-1:0] gm_out [T-1:0];
	reg  [w-1:0] gm_in;

	gfa_mult mults [T-1:0] (reset, clk, gm_in, gm_out);

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
			b <= {2*T{w{'b0}}};
			shift_ct <= 0;
		end else begin

			if (start_T) begin
				shift_ct <= {log_2T{'b1}} - 1;

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
			end else if begin
				gm_in <= 0;
				out_bits <= 0;
				out_valid <= 0;
			end

			/* I doubt this is valid verilog, but it explains the
			 * operation */
			b[2*T-1:1] <= gm_out ^ b[2*T-2:0];
		end
	end

endmodule
