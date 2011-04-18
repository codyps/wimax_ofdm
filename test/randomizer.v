`include "randomizer.v"
`include "test/vect1.v"

module rand_test();

	reg reset, clk, in_bits, in_valid, reload;
	wire out_bits, out_valid;

	reg [14:0] rand_iv;

	reg odata[vect.input_data_sz-1:0];

	randomizer x1(
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
	reg ot;
	initial begin
		$dumpfile("randomizer.lxt");
		$dumpvars();

		clk = 0;
		reset = 0;
		in_bits = 0;
		in_valid = 0;
		reload = 0;
		rand_iv = 0;
		ot = 0;


		#1
		reset = 1;
		#1

		/* device is now reset, iv = 0 */
		set_vect(gen_rand_iv(vect.bsid, vect.uiuc,
			vect.frame_num));

		#1
		clk = 1;
		#1

		o = 0;
		for (i = 0; i < vect.input_data_sz; i = i + 1) begin
			in_valid = 1;
			in_bits = vect.input_data[i];
			clk = 0;
			ot = vect.randomized_data[o];
			#1;
			if (out_valid) begin
				odata[o] = out_bits;
				o = o + 1;
				$display("o: ", out_bits, vect.randomized_data[o]);
			end
			clk = 1;
			#1;
		end

		while (o < vect.input_data_sz) begin
			in_valid = 0;
			clk = 0;
			ot = vect.randomized_data[o];
			#1;
			if (out_valid) begin
				odata[o] = out_bits;
				o = o + 1;
				$display("o: ", out_bits, vect.randomized_data[o]);
			end
			clk = 1;
			#1;
		end
	end

endmodule
