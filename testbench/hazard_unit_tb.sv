
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

	parameter PERIOD = 10;

	//input
  	logic WEN, jumpBranch;
  	logic [4:0] rsel1, rsel2, idexWsel, exmemWsel;
  	//output
  	logic stallPC, ifidFlush, idexFlush, ifidFreze;

  	//test program
  	test PROG(WEN, jumpBranch, rsel1, rsel2, idexWsel, exmemWsel, stallPC, ifidFlush, idexFlush, ifidFreze);

  	//DUT
  	`ifndef MAPPED
	 hazard_unit DUT(WEN, jumpBranch, rsel1, rsel2, idexWsel, exmemWsel, stallPC, ifidFlush, idexFlush, ifidFreze);
	 `else 
	 hazard_unit DUT(
	 	.WEN       (WEN),
	 	.jumpBranch(jumpBranch),
	 	.rsel1     (rsel1),
	 	.rsel2     (rsel2),
	 	.idexWsel  (idexWsel),
	 	.exmemWsel (exmemWsel),
	 	.stallPC   (stallPC),
	 	.ifidFlush (ifidFlush),
	 	.idexFlush (idexFlush),
	 	.ifidFreze (ifidFreze)
	 );
  `endif

endmodule // hazard_unit_tb

program test(
  output logic WEN, jumpBranch,
  output logic [4:0] rsel1, rsel2, idexWsel, exmemWsel,
  input logic stallPC, ifidFlush, idexFlush, ifidFreze
);

initial
	begin
		//Data Hazard
		//RAW and LOAD-USE
		rsel1 = 5'b00001;
		idexWsel = 5'b00001;
		WEN = 1;
		assert(stallPC == 1 && ifidFlush == 0 && idexFlush == 1)
			$info("RAW Hazard passed");
		else
			$error("RAW hazard failed");

		#1
		//Control Hazard
		//Beq an Jump
		WEN = 0;
		jumpBranch = 1;
		assert(stallPC == 0 && ifidFlush == 1 && idexFlush == 1)
			$info("Control Hazard passed");
		else
			$error("Control hazard failed");

		#1
	end	
endprogram