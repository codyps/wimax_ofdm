/* Constelaton Mapping */

/* reset == active high */
module const_mapping
	#(parameter num_width = 16,
	  parameter in_blk = 1,
	  parameter out_blk = 1,
  	  parameter obit_width = num_width * 2 * out_blk,
	  parameter ibit_width = num_width * 2 * in_blk)
	 (input reset, clk,
	  input [ibit_width-1:0] in_data,
	  input in_valid,
	  input  out_ready,
	  output reg [obit_width-1:0] I, Q,
	  output reg out_valid,
	  output reg ready,

	/* XXX: presently ignored, only use QPSK */
	input [4:0] rate_id);

	/* XXX: if in_blk > out_blk, larger buildup occurs */
	localparam max_store_len = (obit_width > ibit_width) ?
		obit_width + obit_width % ibit_width:
		ibit_width + obit_width % ibit_width;

	reg [max_store_len-1:0] inbuf;
	reg [clog2(max_store_len)-1:0] bidx;
	reg should_output;

	always @ (posedge clk or posedge reset)
	if (reset) begin
		inbuf <= 0;
		should_output <= 0;
		bidx <= 0;
		out_valid <= 0;
		ready <= 1;
	end

	always @ (posedge clk) if (~reset) begin
		if (in_valid) begin
			inbuf[2 * ibit_width - 1 -: ibit_width] <= inbuf[ibit_width +: in_blk];
			inbuf[ibit_width-1 -: ibit_width] <= in_data;
			bidx <= bidx + in_blk;
		end

		should_output <= out_ready;
	end

	always @ (negedge clk) if (~reset) begin
		if (bidx > obit_width && should_output) begin
			/* set I and Q */

		end

		if (bidx > max_store_len - in_blk) begin
			/* not enough space, stall */
			ready <= 0;
		end
	end
endmodule
