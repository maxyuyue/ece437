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
  control_if countIf();
  register_file_if rfif();
  alu_file_if aluf ();

  // Declared connections and variables
  word_t	pc, newPC;
  word_t 	extendOut;
  r_t rType;
  

  // Datapath blocks
  register_file rf (CLK, nRST, rfif);
  programCounter progCount (pc, dpif.imemload, extendOut, rfif.rdat1, aluf.zero, countIf, newPC);
  alu_file alu(aluf);
  control controler (dpif.imemload, countIf, dpif.dhit, dpif.ihit);
  requestUnit request(CLK, nRST, countIf.dREN, countIf.dWEN, dpif.ihit, dpif.dhit, dpif.dmemREN, dpif.dmemWEN);

  assign dpif.imemREN = 1;
  assign dpif.dmemstore = rfif.rdat2;
  assign dpif.dmemaddr = aluf.outputPort;


  /********** Halt Signal **********/
  always_ff @(posedge CLK or negedge nRST) begin
  	if (nRST == 0) begin
  		dpif.halt = 0;
  	end
  	else if (dpif.imemload == 32'hffffffff) begin
  		dpif.halt = 1;
  	end
  end
  
  /*
  always_comb begin
  	if (dpif.imemload == 32'hffffffff) begin
  		dpif.halt = 1;
  		//dpif.flushed = 1;
  	end
  	else begin
  		dpif.halt = 0;
  		//dpif.flushed = 0;
  	end
  end
  */
  /********** Halt Signal **********/


  /********** ALU Inputs **********/
  assign aluf.portA = rfif.rdat1;
  assign aluf.aluop = countIf.aluOp;

  always_comb begin // setting port B
  	if (countIf.shiftSel == 1)
  		aluf.portB = dpif.imemload[10:6];
  	else if (countIf.aluSrc == 1) 
  		aluf.portB = extendOut;
  	else
  		aluf.portB = rfif.rdat2;
  end
  /********** ALU Inputs **********/


  /********** Register Inputs **********/
  assign rfif.rsel1 = dpif.imemload[25:21];
  assign rfif.rsel2 = dpif.imemload[20:16];
  assign rfif.WEN = countIf.WEN;
  always_comb begin //wsel iputs
  	if (countIf.jl == 1) begin
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
  	assign dpif.imemaddr = pc;
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
	  	if (countIf.zeroExt == 0) begin // sign extend
	  		extendOut = {dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15:0]};
	  	end
	  	else begin // zero extend
	  		extendOut = {16'b0000000000000000,dpif.imemload[15:0]};
	  	end	
	end


endmodule
