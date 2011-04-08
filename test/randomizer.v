`include "../randomizer"

module rand_test();

	reg reset, clk, in_bits, in_valid, reload;
	wire out_bits, out_valid;

	reg [14:0] rand_iv;

	radnomizer x1(
		reset, clk
		in_bits,
		in_valid,
		out_bits,
		out_valid
		rand_iv,
		reload);

	task shit_in_8;
		input [7:0]idata;
		output[7:0]odata;

		begin
			/* poke clk and in_bits while reading out_bits */
		end
	endtask

	task set_vect;
		input [14:0] new_iv;

		/* insert new_iv into randomizer */

		begin
			rand_iv = new_iv;
			reload = 1;
			clk = 1;
			#10
			clk = 0;
			reload = 0;
		end
	endtask

	initial begin
		clk = reset = in_bits = in_valid = reload = 0;
		rand_iv = 0;

		#10
		reset = 1;
		#10

		/* device is now reset, iv = 0 */


	end


endmodule
