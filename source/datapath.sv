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
  //input signal interfaces to pipeline registers
  pipe_reg_if ifid_input(), idex_input(), exmem_input(), memwb_input();

  //IFID pipeline register input
  ifid_input.regDst = 0;
  ifid_input.branch = 0;.
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


  //IDEX pipeline register input
  idex_input.regDst = countif.regDst;
  idex_input.branch = countif.branch;
  idex_input.WEN = countif.WEN;
  idex_input.aluSrc = countif.aluSrc;
  idex_input.jmp = countif.jmp;
  idex_input.jl = countif.jl;
  idex_input.jmpReg = countif.jmpReg;
  idex_input.memToReg = countif.memToReg;
  idex_input.dREN = countif.dREN;
  idex_input.dWEN = countif.dWEN;
  idex_input.lui = countif.lui;
  idex_input.bne = countif.bne;
  idex_input.zeroExt = countif.zeroExt;
  idex_input.shiftSel = countif.shiftSel;
  idex_input.aluCont = countif.aluCont;
  idex_input.aluOp = countif.aluOp;
  idex_input.instr = ifidValue.instr;
  idex_input.incPC = ifidValue.incPC;
  idex_input.pc = ifidValue.pc;
  idex_input.rdat1 = rfif.rdat1;
  idex_input.rdat2 = rfif.rdat2;
  idex_input.outputPort = 32'b0;


  //EXMEM pipeline register input
  exmem_input.regDst = idexValue.regDst;
  exmem_input.branch = idexValue.branch;
  exmem_input.WEN = idexValue.WEN;
  exmem_input.aluSrc = idexValue.aluSrc;
  exmem_input.jmp = idexValue.jmp;
  exmem_input.jl = idexValue.jl;
  exmem_input.jmpReg = idexValue.jmpReg;
  exmem_input.memToReg = idexValue.memToReg;
  exmem_input.dREN = idexValue.dREN;
  exmem_input.dWEN = idexValue.dWEN;
  exmem_input.lui = idexValue.lui;
  exmem_input.bne = idexValue.bne;
  exmem_input.zeroExt = idexValue.zeroExt;
  exmem_input.shiftSel = idexValue.shiftSel;
  exmem_input.aluCont = idexValue.aluCont;
  exmem_input.aluOp = idexValue.aluOp;
  exmem_input.instr = idexValue.instr;
  exmem_input.incPC = idexValue.incPC;
  exmem_input.pc = idexValue.pc;
  exmem_input.rdat1 = idexValue.rdat1;
  exmem_input.rdat2 = idexValue.rdat2;
  exmem_input.outputPort = aluf.outputPort;


  //MEMWB pipeline register input
  memwb_input.regDst = exmemValue.regDst;
  memwb_input.branch = exmemValue.branch;
  memwb_input.WEN = exmemValue.WEN;
  memwb_input.aluSrc = exmemValue.aluSrc;
  memwb_input.jmp = exmemValue.jmp;
  memwb_input.jl = exmemValue.jl;
  memwb_input.jmpReg = exmemValue.jmpReg;
  memwb_input.memToReg = exmemValue.memToReg;
  memwb_input.dREN = exmemValue.dREN;
  memwb_input.dWEN = exmemValue.dWEN;
  memwb_input.lui = exmemValue.lui;
  memwb_input.bne = exmemValue.bne;
  memwb_input.zeroExt = exmemValue.zeroExt;
  memwb_input.shiftSel = exmemValue.shiftSel;
  memwb_input.aluCont = exmemValue.aluCont;
  memwb_input.aluOp = exmemValue.aluOp;
  memwb_input.instr = exmemValue.instr;
  memwb_input.incPC = exmemValue.incPC;
  memwb_input.pc = exmemValue.pc;
  memwb_input.rdat1 = exmemValue.rdat1;
  memwb_input.rdat2 = exmemValue.rdat2;
  memwb_input.outputPort = exmemValue.outputPort;


  // Pipelines
  pipeRegIFID ifid(CLK, nRST, ifid_input, ifidValue, dpif.ihit, 0);
  pipeRegIDEX idex(CLK, nRST, idex_input, idexValue, dpif.ihit, 0);
  pipeRegEXMEM exmem(CLK, nRST, exmem_input, exmemValue, dpif.ihit, 0);
  pipeRegMEMWB memwb(CLK, nRST, memwb_input, memwbValue, memwbEnable, 0);

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
