/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

`include "control_if.vh"

`include "register_file_if.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;
  control_if contIf();
  register_file_if rfif();

  word_t	pc, newPC;
  word_t 	extendOut;


  register_file rf (CLK, nRST, rfif);
  programCounter progCount (pc, dpif.imemload, extendOut, contIf, rfif.rdat1, newPC);

  control controler (dpif.imemload, contIf);

  // Program counter and update when ihit
  	always_ff @(posedge CLK or negedge nRST) begin
	    if (nRST == 0) begin
	      pc <= PC_INIT;
	    end
	    else begin  
	    	if (dpif.ihit == 1) begin
		    	pc <= newPC;	      
	    	end
	    	else begin
	    		pc <= pc;
	    	end
	    end	   
  	end


  // Zero/Sign Extend Unit
	always_comb begin
	  	if (contIf.zeroExt == 0) begin // sign extend
	  		extendOut = {dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15:0]};
	  	end
	  	else begin // zero extend
	  		extendOut = {16'b0000000000000000,dpif.imemload[15:0]};
	  	end	
	end



endmodule
