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
`include "pipe_reg_if.vh"

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
  word_t	pc, newPC, incPC;
  word_t 	extendOut;
  r_t rType;
  logic memwbEnable;

  //output signal interfaces from pipeline registers
  pipe_reg_if ifidValue(), idexValue(), exmemValue(), memwbValue();
  //input signal interface from to IFID pipeline register
  pipe_reg_if ifid_input();

  //IFID pipeline register input
  ifid_input.regDst = 0;
  ifid_input.branch = 0;
  ifid_input.WEN = 0;
  ifid_input.aluSrc = 0;
  ifid_input.jmp = 0;
  ifid_input.jl = 0;
  ifid_input.jmpReg = 0;
  ifid_input.memToReg = 0;
  ifid_input.dREN = 0;
  ifid_input.dWEN = 0;
  ifid_input.lui = 0;
  ifid_input.bne = 0;
  ifid_input.zeroExt = 0;
  ifid_input.shiftSel = 0;
  ifid_input.aluCont = 0;
  ifid_input.aluOp = 0;
  ifid_input.instr = dpif.imemload;
  ifid_input.incPC = incPC;
  ifid_input.pc = pc;
  ifid_input.rdat1 = 32'h0;
  ifid_input.rdat2 = 32'h0;
  ifid_input.outputPort = 32'h0;


  // Pipelines
  pipeRegIFID ifid(CLK, nRST, ifid_input, ifidValue, dpif.ihit, 0);
  pipeRegIDEX idex(CLK, nRST, ifidValue.branch, ifidValue.WEN, ifidValue.aluSrc, ifidValue.jmp, ifidValue.jl, ifidValue.jmpReg, ifidValue.memToReg, ifidValue.dREN, ifidValue.dWEN, ifidValue.lui, ifidValue.bne, ifidValue.zeroExt, ifidValue.shiftSel, ifidValue.aluCont, ifidValue.aluOp, ifidValue.instr, ifidValue.incPC, ifidValue.pc, rfif.rdat1, rfif.rdat2, 0, idexValue, dpif.ihit, 0);
  pipeRegEXMEM exmem(CLK, nRST, idexValue.branch, idexValue.WEN, idexValue.aluSrc, idexValue.jmp, idexValue.jl, idexValue.jmpReg, idexValue.memToReg, idexValue.dREN, idexValue.dWEN, idexValue.lui, idexValue.bne, idexValue.zeroExt, idexValue.shiftSel, idexValue.aluCont, idexValue.aluOp, idexValue.instr,  idexValue.incPC, idexValue.pc, idexValue.rdat1, idexValue.rdat2, aluf.outputPort, exmemValue, dpif.ihit, 0);
  pipeRegMEMWB memwb(CLK, nRST, exmemValue.branch, exmemValue.WEN, exmemValue.aluSrc, exmemValue.jmp, exmemValue.jl, exmemValue.jmpReg, exmemValue.memToReg, exmemValue.dREN, exmemValue.dWEN, exmemValue.lui, exmemValue.bne, exmemValue.zeroExt, exmemValue.shiftSel, exmemValue.aluCont, exmemValue.aluOp, exmemValue.instr, exmemValue.incPC, exmemValue.pc, exmemValue.rdat1, exmemValue.rdat2, exmemValue.outputPort, memwbValue, memwbEnable, 0);

  // Datapath blocks
  register_file rf (CLK, nRST, rfif);
  programCounter progCount (pc, idexValue.instr, extendOut, idexValue.rdat1, aluf.zero, idexValue.branch, idexValue.WEN, idexValue.aluSrc, idexValue.jmp, idexValue.jl, idexValue.jmpReg, idexValue.memToReg, idexValue.dREN, idexValue.dWEN, idexValue.lui, idexValue.bne, idexValue.zeroExt, idexValue.shiftSel, idexValue.aluCont, idexValue.aluOp, newPC, incPC);
  alu_file alu(aluf);
  control controler (idexValue.instr, countIf, dpif.dhit, dpif.ihit);


  assign dpif.imemREN = ~dpif.halt;
  assign dpif.dmemstore = rfif.rdat2;
  assign dpif.dmemaddr = aluf.outputPort;
  assign memwbEnable = dpif.ihit & dpif.dhit;
  assign dpif.dmemREN = exmemValue.dREN; // instead of request unit
  assign dpif.dmemWEN = exmemValue.dWEN; // instead of request unit




  /********** Program Counter Update **********/
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
  /********** Program Counter Update **********/


  /********** Register Inputs **********/
  assign rfif.rsel1 = ifidValue.instr[25:21];
  assign rfif.rsel2 = ifidValue.instr[20:16];
  assign rfif.WEN = memwbValue.WEN;
  always_comb begin //wsel iputs
    if (memwbValue.jl == 1) begin
      rfif.wsel = 31;
    end
    else begin
      if (memwbValue.regDst == 1)
        rfif.wsel = dpif.imemload[15:11];
      else
        rfif.wsel = dpif.imemload[20:16];
    end
  end

  always_comb begin // wdat inputs
    if (memwbValue.lui == 1) 
      rfif.wdat = {dpif.imemload[15:0],16'b0000000000000000};
    else begin
      if (memwbValue.jl == 1)
        rfif.wdat = pc +4;
      else begin
        if (memwbValue.memToReg == 1)
          rfif.wdat = dpif.dmemload;
        else 
          rfif.wdat = aluf.outputPort;
      end
    end
  end
  /********** Register Inputs **********/


  /********** Zero or Sign Extend Unit **********/
  always_comb begin
      if (idexValue.zeroExt == 0) begin // sign extend
        extendOut = {dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15],dpif.imemload[15:0]};
      end
      else begin // zero extend
        extendOut = {16'b0000000000000000,dpif.imemload[15:0]};
      end 
  end
  /********** Zero or Sign Extend Unit **********/


  /********** ALU Inputs **********/
  assign aluf.portA = idexValue.rdat1;
  assign aluf.aluop = idexValue.aluOp;

  always_comb begin // setting port B
  	if (idexValue.shiftSel == 1)
  		aluf.portB = idexValue.instr[10:6];
  	else if (idexValue.aluSrc == 1) 
  		aluf.portB = extendOut;
  	else
  		aluf.portB = idexValue.rdat2;
  end
  /********** ALU Inputs **********/


  /********** Halt Signal **********/
  always_ff @(posedge CLK or negedge nRST) begin
    if (nRST == 0) begin
      dpif.halt = 0;
    end
    else if (memwbValue.instr == 32'hffffffff) begin
      dpif.halt = 1;
    end
  end
  /********** Halt Signal **********/

endmodule
