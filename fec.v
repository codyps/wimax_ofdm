/* FEC is composed of 2 portions, reed solomon and convolution code,
* applied in that order. */

module fec(
	input reset, clk
	input in_bits,
	input in_valid,
	output out_bits,
	output out_valid,
	input [3:0] rate_id
	/* FIXME: I think this needs more inputs */
	);

	always @ (posedge clk or posedge reset) begin
		
	end

	always @ (negedge clk or posedge reset) begin

	end

endmodule

/* convolution code - this one is based on the Figure 202 of 802.16-2009,
 * labeled "1/2 rate". Seems to indicate 2 bit output per 1 bit input.
 */
module cc_base(
	/* ?? */
	input reset, clk,
	input valid_in,
	input cur_in,
	output reg [1:0] z,
	output reg valid_out
	);

	reg [5:0] state;
	reg in_progress;
	wire x, y;

	assign x = state[0] | state[1] | state[2] | state[5] | cur_in;
	assign y = state[1] | state[2] | state[4] | state[5] | cur_in;

	/**
	* This is a 1 bit width design which has similar concerns as the 1 bit
	* reed solomon
	*/

	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			state <= 0;
			in_progress <= 0;
		end else begin
			if (valid_in) begin
				in_progress <= 1;

				/* shift */
				state[5:0] <= { state[4:0], cur_in };
			end else if (in_progress) begin
				/* TODO: flush out remaining data, set
				* in_progress = 1 when all needed data has
				* escaped. Note that in_progress is used on
				* the negedge, so it needs to be cleared after
				* the data is shifted out, not just read in.
				*/
			end else begin
				/* XXX: do we need anything here? */		
			end
		end
	end

	always @ (negedge clk or posedge reset) begin
		if (reset) begin
			z <= 0;
			valid_out <= 0;
		end else begin
			if (in_progress) begin
				z[0] <= x;
				z[1] <= y;
				valid_out <= 1;
			end
		end
	end
endmodule

/* reed solomon encoding */
module rs_enc(
	);

	/* The Reed-Solomon encoding shall be derived from a systematic RS (N
	 * = 255, K = 239, T = 8) code using
	 * GF(2^8),
	 */

	/* Field generator polynomial
	 * p(x) = x^8 + x^4 + x^3 + x^2 + 1
	 */

	/* Code generator polynomial
	 * ?(x) = (x + λ^0)(x + λ^1)(x + λ^2)…(x + λ^(2T – 1)), λ = 02HE
	 */

	/* Galios field operations:
	 * addition: xor
	 * multiplication: multiplication modulo the generator polynomial
	 */

	always @ (reset) if (reset == 0) begin
	end

	always @ (posedge clk) begin
	end

	always @ (negedge clk) begin
	end


endmodule
