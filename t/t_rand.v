`include "rand.v"
`include "t/vect/2.v"

module rand_test();

	localparam w = 8;

	reg reset, clk, in_valid, reload;
	reg  [w-1:0] in_bits;
	wire [w-1:0] out_bits;
	wire out_valid;

	reg [14:0] rand_iv;

	reg odata[0:vect.input_data_sz-1];

	rand_parm #(w) x1(
		reset, clk,
		in_bits,
		in_valid,
		out_bits,
		out_valid,
		rand_iv,
		reload);

	task set_vect;
		input [14:0] new_iv;

		/* insert new_iv into randomizer */
		begin
			clk = 1;
			#1
			reload = 1;
			rand_iv = new_iv;
			clk = 0;
			#1
			clk = 1;
			#1
			rand_iv = 0;
			reload = 0;
		end
	endtask

	`include "func/gen_rand_iv.v"

	integer i, o;
	initial begin
		$dumpfile("randomizer.lxt");
		$dumpvars();

		clk = 0;
		reset = 0;
		in_bits = 0;
		in_valid = 0;
		reload = 0;
		rand_iv = 0;

		#1
		reset = 1;
		#1
		
		reset = 0;

		/* device is now reset, iv = 0 */
		set_vect(gen_rand_iv(vect.bsid, vect.uiuc,
			vect.frame_num));

		#1
		clk = 1;
		#1

		o = 0;

		$display("iv: %b", x1.vect);
		for (i = 0; i < vect.input_data_sz; i = i + w) begin
			in_valid = 1;
			in_bits = vect.input_data[i +: w];
			clk = 0;
			#1;
			clk = 1;

			/* read on the rising edge */

			if (out_valid) begin
				//odata[o +: w] = out_bits;
				$display("r: %b => %b %b %b", vect.input_data[o +: w], out_bits, vect.randomized_data[o +: w], x1.vect);
				o = o + w;
			end else begin
				$display("skip");
			end
			#1;

		end

		while (o < vect.input_data_sz) begin
			in_valid = 0;
			clk = 0;
			#1;
			if (out_valid) begin
				//odata[o +: w] = out_bits;
				$display("r: %b => %b %b %b", vect.input_data[o +: w], out_bits, vect.randomized_data[o +: w], x1.vect);
				o = o + w;
			end
			clk = 1;
			#1;
		end
	end

endmodule
