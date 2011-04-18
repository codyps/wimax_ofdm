module test();

	parameter w = 4;
	reg [w-1:0] x;

	reg [w-1:0] y;

	reg [0:w-1] z;

	wire [3*w-1:0] q;

	assign q = { x, y, z};

	wire [w-1:0] rev;
	generate
		genvar i;
		for (i = 0; i < w; i = i + 1) begin
			assign rev[i] = x[w-i-1];
		end
	endgenerate

	initial begin
		$monitor("x %b y %b z %b rev %b q %b", x, y, z, rev, q);
		x = 5;
		#1 y = {x[0], x[1], x[2], x[3]}; // y = flipped x
		#1 y = x[0 +: 4]; // y = x
		#1 y = x[3 -: 4]; // y = x
		///#1 y = x[0:3]; // error.
		//
		z = 5;

	end

endmodule
