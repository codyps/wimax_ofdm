

/*
* chain of modules :
*	randomizer (rand.v; also known as whitener)
*		depends on: ???
*	convolution coder with padding (conv.v; For BPSK rate = 1/2)
*		depends on: ???
*	-- Reed Solomon encoder: bypassed for BPSK.
*	channel mapper (chan_map.v; )
*		depends on: ???
*	IFFT (ifft.v; )
*		depends on: ???
*		operates on: ???
*/

module WIMAX
	#(
	parameter O = 16 /* Analog output width */
	)
	(
	input clk, reset,
	input  i, i_valid,
	output [O-1:0] Q, I,
	output qi_valid
	);



	


endmodule
