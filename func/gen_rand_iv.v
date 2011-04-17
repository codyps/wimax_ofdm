
function [14:0] gen_rand_iv;
	input [3:0] bsid;
	input [3:0] uiuc;
	input [3:0] fnum;

	gen_rand_iv = {
		fnum[0], fnum[1], fnum[2], fnum[3],
		1'b1,
		uiuc[0], uiuc[1], uiuc[2], uiuc[3],
		2'b11,
		bsid[0], bsid[1], bsid[2], bsid[3]
		};
endfunction
