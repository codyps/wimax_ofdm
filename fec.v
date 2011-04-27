/* FEC is composed of 2 portions, reed solomon and convolution code,
 * applied in that order. On non-subchannelized data, RS is bypassed */

module fec(
	input reset, clk,
	input in_bits,
	input in_valid,
	output out_bits,
	output out_valid,

	/* config */
	input enable_rs,
	input [1:0] cc_rate
	);

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

