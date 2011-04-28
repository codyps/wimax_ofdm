
`include "param.v"

/* convolution code - this one is based on the Figure 202 of 802.16-2009,
 * labeled "1/2 rate". Seems to indicate 2 bit output per 1 bit input.
 */
module cc_base(
	input reset, clk,
	input valid_in,
	input cur_in,
	output reg [1:0] z,
	output reg valid_out
	);

	reg [5:0] state;
	reg in_progress;
	wire x, y;

	assign x = state[0] ^ state[1] ^ state[2] ^ state[5] ^ cur_in;
	assign y = state[1] ^ state[2] ^ state[4] ^ state[5] ^ cur_in;

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

/* Buffers the output of cc_base into something the next stage in the pipeline
 * wants. Also handles the needed discards for the requested rate.
 */
module cc
	#(
	parameter w = 1,
	parameter in_width  = w,
	parameter out_width = w,
  	parameter ncbps     = 768,
	parameter buf_sz    = ncbps / 2,
	parameter baddr_sz  = $clog2(buf_sz),
	parameter cc_base_o_width = 2
	)(
	input reset, clk,
	input [in_width-1:0] cur_in,
	input valid_in,
	output reg [out_width-1:0] z,
	output reg valid_out,

	input [p_cc_rate.w-1:0] cc_rate
	);

	/* cc_base connections */
	wire [cc_base_o_width-1:0] base_out;
	wire base_valid_out;

	/* buffering/fifo */
	reg [buf_sz-1:0] dbuf;
	reg [baddr_sz-1:0] i_loc;
	reg [baddr_sz-1:0] o_loc;

	/* "next", to be assigned to outputs on negedge. */
	reg [out_width-1:0] nout;
	reg nvalid;

	cc_base cc(reset, clk, valid_in, cur_in, base_out, base_valid_out);

	always @(posedge clk or posedge reset) begin
		if (reset) begin
			i_loc <= 0;
			o_loc <= 0;
		end else begin
			if (base_valid_out) begin
				dbuf[i_loc +: cc_base_o_width] <= base_out;
				i_loc <= i_loc + cc_base_o_width;
			end else begin

			end
		end
	end

	always @(negedge clk or posedge reset) begin
		if (reset) begin
			z         <= 0;
			valid_out <= 0;
		end else begin
			z         <= nout;
			valid_out <= nvalid;
		end
	end

endmodule
