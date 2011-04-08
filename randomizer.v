module randomizer(
	input reset, clk
	input in_bits,
	input in_valid,
	output reg out_bits,
	output reg out_valid
	input [14:0] rand_iv,
	input reload);

	reg [14:0] vect;
	reg nout;
	reg nvalid;

	/* XXX: EFFICIENCY: there should be a way to do this 8 bits at a time,
	 * as mentioned in "OFDM Baseband Transmitter Implementation Compliant
	 * IEEE Std 802.16d on FPGA"
	 */

	always @(reset) begin
		nout = 0;
		nvalid = 0;
		out_bits = 0;
		out_valid = 0;
		vect = rand_iv;
	end

	always @ (posedge clk) begin
		if (reload) begin
			vect = rand_iv;
		end else if (in_valid) begin
			nout = in_bits ^ (vect[13] ^ vect[14]);
			nvalid = 1;
			vect[1:14] = vect[0:15];
			vect[0] = vect[13] ^ vect[14];
		end else begin
			nvalid = 0;
			nout = x;
		end
	end

	always @ (negedge clk) begin
		out_valid = nvalid;
		out_bits = nout;
	end

endmodule
