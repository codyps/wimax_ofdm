/* Cyclic Prefix.
* NOTE TO SELF: do not attempt to pipeline!.
* set the in_ready = 0 when the input data has been exausted.
*/


module cp
	#(parameter num_sz = 16,
	  parameter max_tg = 128,
	  parameter in_blk = 1,
	  parameter out_blk = 1,
	  parameter obits = out_blk * 2 * num_sz,
	  parameter ibits = in_blk * 2 * num_sz
  	)(
	input reset, clk,

	input load,

	/* the prefix time (sample ct) */
	input [/*xxx*/0:0] param_Tg,

	input [ibits-1:0] in_data,
	input in_valid,
	output in_ready,

	output [obits-1:0] out_data,
	output out_valid,
	input  out_ready
	);

	reg [/*xxx*/0:0] tg;

	localparam buf_sz = max_tg + ibits;
	reg [buf_sz-1:0] dbuf;
	reg [clogb2(buf_sz)-1:0] dct;
	reg [clogb2(buf_sz)-1:0] pct;

	always @ (posedge clk or posedge reset) 
	if (reset) begin
		tg <= param_Tg;
		dbuf <= 0;
		dct <= tg;
	end

	always @ (posedge clk) begin
	if (~reset) begin
		if (load) begin
			tg <= param_Tg;
			dct <= param_Tg;
		end

		if (in_valid) begin
			dbuf[2 * ibits-1 -: ibits] <=
				dbuf[ibits-1 -: ibits];

			dbuf[ibits-1 -: ibits] <= in_data;

			dct <= dct + ibits;
		end else begin
			/* have we been reading in data? */
			if (dct + ibits > tg) begin
				/* finish outputing this burst,
				* new bursts are blocked */
			end
		end
	end

	always @ (negedge clk)
	if (~reset) begin
		if (out_ready) begin
			if (dct > tg) begin
				out_data <= dbuf[dct -: obits];
			end

			if (dct - obits =< tg) begin
				pct <= dct - obits;
			end

			if (dct < tg) begin
				/* XXX: */

			end
		end

		/* dct + one more load would overflow buffer. */
		if (dct > buf_sz - ibits)
			in_ready <= 0;
		else
			in_ready <= 1;
	end

endmodule
