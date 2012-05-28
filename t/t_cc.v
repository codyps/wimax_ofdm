`include "t/vect/1.v"
`include "fec.v"

module test();

	integer w = 1;
	integer o_w = 2;
	reg reset, clk, valid_in, cur_in;
	wire [o_w-1:0] z;
	wire valid_out;



	cc_base x1(reset, clk, valid_in, cur_in, z, valid_out);

	integer i, o;
	initial begin
		$dumpfile("cc.txt");
		$dumpvars();


		clk = 0;
		reset = 0;
		cur_in = 0;
		valid_in = 0;

		#1
		reset = 1;
		#1

		reset = 0;

		#1
		clk = 1;
		#1

		//$display("iv: %b", x1.vect);
		for (i = 0; i < vect.rs_data_size; i = i + w) begin
			in_valid = 1;
			in_bits = vect.rs_encoded_data[i +: w];
			clk = 0;
			#1;
			clk = 1;

			/* read on the rising edge */

			if (out_valid) begin
				$display("r: %b => %b : %b", vect.rs_encoded_data[o +: o_w], z, vect.cc_encoded_data[o +: o_w]);
				o = o + o_w;
			end else begin
				$display("skip");
			end
			#1;

		end

		while (o < vect.rs_data_sz) begin
			in_valid = 0;
			clk = 0;
			#1;
			if (out_valid) begin
				$display("r: %b => %b : %b", vect.rs_encoded_data[o +: o_w], z, vect.cc_encoded_data[o +: o_w]);
				o = o + o_w;
			end
			clk = 1;
			#1;
		end
	end


	end

endmodule
