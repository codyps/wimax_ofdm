

/* reed solomon encoding */
module rs_enc(
	input reset, clk
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

	always @(posedge clk or posedge reset) begin
		if (reset) begin
		end else begin
		end
	end

	always @(negedge clk or posedge reset) begin
		if (reset) begin
		end else begin
		end
	end

endmodule
