`ifndef PARAM_V_
`define PARAM_V_

module p_rate_id();
	parameter w = 2;

	parameter BPSK = 0;
	parameter QPSK = 1;
	parameter QAM16 = 2;
	parameter QAM64 = 3;
endmodule

module p_cc_rate();
	parameter w = 2;

	parameter r_1_2 = 0;
	parameter r_3_4 = 1;
	parameter r_5_6 = 2;
endmodule

/* FIXME: this is just thrown together */
/* Mod    16   8   4   2   1
 * BPSK   192  96  48  24  12
 * QPSK   384  192 96  48  24
 * 16-QAM 768  384 192 96  48
 * 64-QAM 1152 576 288 144 72
 */
module p_subchan_id();
	parameter ct = 4;
	parameter w  = 2;
endmodule

module p_subchan_ct();
	parameter ct = 5;
	parameter w  = 3;
endmodule


`endif
