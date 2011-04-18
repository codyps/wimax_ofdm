module p_rate_id();
	parameter BPSK = 0;
	parameter QPSK = 1;
	parameter QAM16 = 2;
	parameter QAM64 = 3;
endmodule

module p_cc_rate();
	parameter r_1_2 = 0;
	parameter r_3_4 = 1;
	parameter r_5_6 = 2;
endmodule
