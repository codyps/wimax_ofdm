/* FEC is composed of 2 portions, reed solomon and convolution code,
 * applied in that order. On non-subchannelized data, RS is bypassed */

`include "rs.v"
`include "cc.v"

module fec
	#(
	parameter w = 1
	)(
	input reset, clk,
	input [w-1:0] in_bits,
	input in_valid,
	output [w-1:0] out_bits,
	output out_valid,

	/* config */
	input enable_rs,
	input [1:0] cc_rate
	);

	/** RS **/
	reg [w-1:0] rs_in_bits;
	reg rs_in_valid;

	wire [w-1:0] rs_out_bits;
	wire rs_out_valid;

	rs rs1 #(.w(w)) (reset, clk,
		rs_in_bits,
		rs_in_valid,
		rs_out_bits,
		rs_out_valid
	);
	/** **/

	/** CC **/
	reg [w-1:0] cc_in_bits;
	reg cc_in_valid;

	wire [w-1:0] cc_out_bits;
	wire cc_out_valid;

	cc cc1 #(.w(w)) (reset, clk,
		cc_in_bits,
		cc_in_valid,
		cc_out_bits,
		cc_out_valid,

		cc_rate
	);
	/** **/

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

