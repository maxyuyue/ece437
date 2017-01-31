/*
  Kyle Rakos

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"
`include "control_if.vh"
`include "register_file_if.vh"
`include "alu_file_if.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  // Declared interfaces 
  control_if contIf();
  register_file_if rfif();
  alu_file_if aluf ();

  // Declared connections and variables
  word_t	pc, newPC;
  word_t 	extendOut;


  // Datapath blocks
  register_file rf (CLK, nRST, rfif);
  programCounter progCount (pc, dpif.imemload, extendOut, contIf, rfif.rdat1, newPC);
  alu_file alu(aluf);
  control controler (dpif.imemload, contIf);
  requestUnit request(CLK, nRST, contIf.dREN, contIf.dWEN, dpif.ihit, dpif.dhit, dpif.dmemREN, dpif.dmemWEN);

  /********** Register Inputs **********/
  assign rfif.rsel1 = dpif.imemload[25:21];
  assign rfif.rsel2 = dpif.imemload[20:16];

  always_comb begin //wsel iputs
  	if (contIf.jl == 1) begin
  		rfif.wsel = 31;
  	end
  	else begin
  		if (countIf.regDst == 1)
  			rfif.wsel = dpif.imemload[15:11];
  		else
  			rfif.wsel = dpif.imemload[20:16];
  	end
  end

  always_comb begin // wdat inputs
  	if (countIf.lui == 1) 
  		rfif.wdat = {dpif.imemload[15:0],16'b0000000000000000};
  	else begin
  		if (countIf.jl == 1)
  			rfif.wdat = pc +4;
  		else begin
  			if (countIf.memToReg == 1)
  				rfif.wdat = dpif.dmemload;
  			else 
  				rfif.wdat = aluf.outputPort;
  		end
  	end
  end
  /********** Register Inputs **********/

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


  	// Zero or Sign Extend Unit
	always_comb begin
	  	if (contIf.zeroExt == 0) begin // sign extend
	  		extendOut = {dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15:0]};
	  	end
	  	else begin // zero extend
	  		extendOut = {16'b0000000000000000,dpif.imemload[15:0]};
	  	end	
	end


endmodule
