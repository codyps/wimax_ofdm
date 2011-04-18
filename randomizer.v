module randomizer(
	input reset, clk,
	input in_bits,
	input in_valid,
	output reg out_bits,
	output reg out_valid,
	input [14:0] rand_iv,
	input reload);

	reg [14:0] vect;
	reg nout;
	reg nvalid;

	/* XXX: EFFICIENCY: there should be a way to do this 8 bits at a time,
	 * as mentioned in "OFDM Baseband Transmitter Implementation Compliant
	 * IEEE Std 802.16d on FPGA" */

	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			nout   <= 0;
			nvalid <= 0;
			vect   <= 0;
		end else begin
			if (reload) begin
				nvalid <= 0;
				nout   <= 0;
				vect   <= rand_iv;
			end else if (in_valid) begin
				nvalid <= 1;
				nout   <= in_bits ^ (vect[13] ^ vect[14]);
				vect   <= { vect[13:0], vect[13] ^ vect[14] };
			end else begin
				nvalid <= 0;
				nout   <= 0;
				vect   <= vect;
			end
		end
	end

	always @ (negedge clk) begin
		out_valid <= nvalid;
		out_bits  <= nout;
	end

endmodule

/* Processes 8 (or some variation between 1 and 14 bits) at a time */
module rand_parm
	#(parameter bits_pclk = 8)(
	input reset, clk,
	input [bits_pclk-1:0] in_bits,
	input in_valid,
	output reg [bits_pclk-1:0] out_bits,
	output reg out_valid,
	input [14:0] rand_iv,
	input reload);

	reg [14:0] vect;
	reg [bits_pclk-1:0] nvect;
	reg [bits_pclk-1:0]  nout;
	reg nvalid;

	always @ (posedge clk or posedge reset) begin
		if (reset) begin
			nvalid <= 0;
			nout   <= 0;
			vect   <= 0;
		end else begin
			if (reload) begin
				nvalid <= 0;
				nout   <= 0;
				vect   <= rand_iv;
			end else if (in_valid) begin
				nvalid <= 1;
				nvect[bits_pclk-1:0] =
					vect[13-:bits_pclk] ^ vect[14-:bits_pclk];
				nout[bits_pclk-1:0]  =
					nvect[bits_pclk-1:0] ^ nvect[bits_pclk-1:0];
			end else begin
				nvalid <= 0;
				nout   <= 0;
				vect   <= vect;
			end
		end
	end

	always @ (negedge clk) begin
		out_valid = nvalid;
		out_bits = nout;
	end

endmodule
