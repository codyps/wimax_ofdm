`include "common_widths.v"

module vect();

/*
 * Modulation mode: QPSK, rate 3/4, Symbol Numbers within burst: 1-5,
 * UIUC: 7, BSID: 1, Frame Number: 1, subchannel index: 0b00001 (decimal values)
 */

parameter uiuc = 7;
parameter bsid = 1;
parameter frame_num = 1;
parameter subchannel_index = 'b00001;
parameter input_data_sz = 80;

reg [0:input_data_sz-1] input_data =      'h45_29_C4_79_AD_0F_55_28_AD_87;

/* NOTE—The last hex value represents 2 bits only. */
reg [0:input_data_sz-1] randomized_data = 'hD4_BA_A1_12_F2_74_96_30_27_D4;
//reg [159:0] randomized_data = 'hD4_BA_A1_12_F2_74_96_30_27_D4_00_00;

/* Convolutionally encoded data (Hex) */
//reg convolution_encoded_data = 'hEE_C6_A1_CB_7E_04_73_6C_BC_61_95_D3_B7_DF_00;

/* Interleaved data (Hex) */
//reg interleaved_data = 'hBC_EC_A1_F4_8A_3A_7A_4F_78_39_53_87_DF_2A_A2;

/*
Subcarrier mapping (frequency offset index: I value Q value)
1st data symbol:
-100: -1 1, -99: -1 -1, -98: -1 -1, -37: 1 1, -36: -1 -1, -35: -1 1, 1: -1 -1, 2: 1 1, 3: -1 1, 64: -1 1,
65: 1 1, 66: 1 -1
2nd data symbol:
-100: -1 -1, -99: -1 -1, -98: 1 -1, -37: 1 1, -36: -1 1, -35: 1 1, 1: -1 1, 2: -1 1, 3: 1 1, 64: -1 -1, 65:
-1 1, 66: -1 1
3rd data symbol:
-100: 1 -1, -99: -1 -1, -98: -1 1, -37: -1 1, -36: 1 -1, -35: 1 1, 1: -1 -1, 2: -1 -1, 3: 1 -1, 64: -1 -1,
65: -1 1, 66: 1 1
4th data symbol:
-100: 1 1, -99: -1 -1, -98: -1 1, -37: 1 -1, -36: 1 -1, -35: 1 -1, 1: 1 1, 2: -1 -1, 3: -1 1, 64: 1 1, 65:
1 -1, 66: -1 -1
5th data symbol:
-100: -1 -1, -99: 1 -1, -98: -1 -1, -37: -1 -1, -36: 1 1, -35: -1 1, 1: -1 1, 2: -1 1, 3: -1 1, 64: -1 1,
65: 1 1, 66: -1 1
Note that the above QPSK values are to be normalized with a factor 1 ⁄ 2 as indicated in Figure 205.
*/

endmodule

