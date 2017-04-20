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
`include "pipe_reg_ifid_if.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

  // Declared connections and variables
  word_t  pc, newPC, incPC, extendOut, rdat1Fwd, rdat2Fwd;
  opcode_t opC, opCif, opCid, opCex, opCmem, opCwb;
  funct_t func, funcif, funcid, funcex, funcmem, funcwb;
  logic memwbEnable, exmemFlush, stallPC, jumpBranch, ifidFlush, idexFlush, ifidFreze, ifidEnable, r1Fwd, r2Fwd;

  logic ihitEnable;

  // Declared interfaces 
  control_if countIf(), countIfPC();
  register_file_if rfif();
  alu_file_if aluf ();
  pipe_reg_if idexValue(), exmemValue(), memwbValue(), memwbValueOld(); //output signal interfaces from pipeline registers
  pipe_reg_if idex_input(), exmem_input(), memwb_input(); //input signal interfaces to pipeline registers
  pipe_reg_ifid_if ifidValue(), ifid_input();

  // Just used for debugging
  always_comb begin
    if (ihitEnable == 1) begin
      opC = opcode_t'(dpif.imemload [31:26]);
      func = funct_t'(dpif.imemload[5:0]);
      opCif = opcode_t'(dpif.imemload [31:26]);
      funcif = funct_t'(dpif.imemload[5:0]);
      opCid = opcode_t'(ifidValue.instr[31:26]);
      funcid = funct_t'(ifidValue.instr[5:0]);
      opCex = opcode_t'(idexValue.instr [31:26]);
      funcex = funct_t'(idexValue.instr[5:0]);
      opCmem = opcode_t'(exmemValue.instr [31:26]);
      funcmem = funct_t'(exmemValue.instr[5:0]);
      opCwb = opcode_t'(memwbValue.instr [31:26]);
      funcwb = funct_t'(memwbValue.instr[5:0]);
    end
  end


  //IFID pipeline register input
  assign ifid_input.aluOp = ALU_SLL;
  assign ifid_input.instr = dpif.imemload;
  assign ifid_input.incPC = incPC;
  assign ifid_input.pc = pc;


  //IDEX pipeline register input
  assign idex_input.regDst = countIf.regDst;
  assign idex_input.branch = countIf.branch;
  assign idex_input.WEN = countIf.WEN;
  assign idex_input.aluSrc = countIf.aluSrc;
  assign idex_input.jmp = countIf.jmp;
  assign idex_input.jl = countIf.jl;
  assign idex_input.jmpReg = countIf.jmpReg;
  assign idex_input.dREN = countIf.dREN;
  assign idex_input.dWEN = countIf.dWEN;
  assign idex_input.lui = countIf.lui;
  assign idex_input.bne = countIf.bne;
  assign idex_input.zeroExt = countIf.zeroExt;
  assign idex_input.shiftSel = countIf.shiftSel;
  assign idex_input.aluOp = countIf.aluOp;
  assign idex_input.instr = ifidValue.instr;
  assign idex_input.incPC = ifidValue.incPC;
  assign idex_input.pc = ifidValue.pc;
  assign idex_input.rdat1 = rfif.rdat1;
  assign idex_input.rdat2 = rfif.rdat2;
  assign idex_input.outputPort = 32'h0;
  assign idex_input.dmemload = 32'h0;
  assign idex_input.ll = countIf.ll;
  always_comb begin //wsel iputs
    if (countIf.jl == 1) begin
      idex_input.dest = 5'd31;
    end
    else begin
      if (countIf.regDst == 1)
        idex_input.dest = ifidValue.instr[15:11];
      else
        idex_input.dest = ifidValue.instr[20:16];
    end
  end


  //EXMEM pipeline register input
  assign exmem_input.regDst = idexValue.regDst;
  assign exmem_input.branch = idexValue.branch;
  assign exmem_input.WEN = idexValue.WEN;
  assign exmem_input.aluSrc = idexValue.aluSrc;
  assign exmem_input.jmp = idexValue.jmp;
  assign exmem_input.jl = idexValue.jl;
  assign exmem_input.jmpReg = idexValue.jmpReg;
  assign exmem_input.dREN = idexValue.dREN;
  assign exmem_input.dWEN = idexValue.dWEN;
  assign exmem_input.lui = idexValue.lui;
  assign exmem_input.bne = idexValue.bne;
  assign exmem_input.zeroExt = idexValue.zeroExt;
  assign exmem_input.shiftSel = idexValue.shiftSel;
  assign exmem_input.aluOp = idexValue.aluOp;
  assign exmem_input.instr = idexValue.instr;
  assign exmem_input.incPC = idexValue.incPC;
  assign exmem_input.pc = idexValue.pc;
  assign exmem_input.rdat1 = idexValue.rdat1;
  //exmem_input.rdat2 moved below
  assign exmem_input.outputPort = aluf.outputPort;
  assign exmem_input.dmemload = 32'h0;
  assign exmem_input.dest = idexValue.dest;
  assign exmem_input.ll = idexValue.ll;


  //MEMWB pipeline register input
  assign memwb_input.regDst = exmemValue.regDst;
  assign memwb_input.branch = exmemValue.branch;
  assign memwb_input.WEN = exmemValue.WEN;
  assign memwb_input.aluSrc = exmemValue.aluSrc;
  assign memwb_input.jmp = exmemValue.jmp;
  assign memwb_input.jl = exmemValue.jl;
  assign memwb_input.jmpReg = exmemValue.jmpReg;
  assign memwb_input.dREN = exmemValue.dREN;
  assign memwb_input.dWEN = exmemValue.dWEN;
  assign memwb_input.lui = exmemValue.lui;
  assign memwb_input.bne = exmemValue.bne;
  assign memwb_input.zeroExt = exmemValue.zeroExt;
  assign memwb_input.shiftSel = exmemValue.shiftSel;
  assign memwb_input.aluOp = exmemValue.aluOp;
  assign memwb_input.instr = exmemValue.instr;
  assign memwb_input.incPC = exmemValue.incPC;
  assign memwb_input.pc = exmemValue.pc;
  assign memwb_input.rdat1 = exmemValue.rdat1;
  assign memwb_input.rdat2 = memwbValue.rdat2;
  assign memwb_input.outputPort = exmemValue.outputPort;
  assign memwb_input.dmemload = dpif.dmemload;
  assign memwb_input.dest = exmemValue.dest;
  assign memwb_input.ll = exmemValue.ll;


  // Control Interface for Program Counter
  assign countIfPC.regDst = idexValue.regDst;
  assign countIfPC.branch = idexValue.branch;
  assign countIfPC.WEN = idexValue.WEN;
  assign countIfPC.aluSrc = idexValue.aluSrc;
  assign countIfPC.jmp = idexValue.jmp;
  assign countIfPC.jl = idexValue.jl;
  assign countIfPC.jmpReg = idexValue.jmpReg;
  assign countIfPC.dREN = idexValue.dREN;
  assign countIfPC.dWEN = idexValue.dWEN;
  assign countIfPC.lui = idexValue.lui;
  assign countIfPC.zeroExt = idexValue.zeroExt;
  assign countIfPC.bne = idexValue.bne;
  assign countIfPC.shiftSel = idexValue.shiftSel;
  assign countIfPC.aluOp = idexValue.aluOp;
  assign countIfPC.ll = idexValue.ll;



  // Pipelines
  pipeRegIFID ifid(CLK, nRST, ihitEnable, ifid_input, ifidValue, ifidEnable, ifidFlush);
  pipeRegIDEX idex(CLK, nRST, ihitEnable, idex_input, idexValue, ihitEnable, idexFlush);
  pipeRegEXMEM exmem(CLK, nRST, ihitEnable, exmem_input, exmemValue, ihitEnable, exmemFlush);
  pipeRegMEMWB memwb(CLK, nRST, ihitEnable, memwb_input, memwbValue, memwbValueOld, memwbEnable, 1'b0);

  // Datapath blocks
  register_file rf (CLK, nRST, rfif);
  programCounter progCount (pc, idexValue.pc, idexValue.instr, extendOut, idexValue.rdat1, aluf.zero, countIfPC, newPC, incPC, jumpBranch);
  alu_file alu(aluf);
  control controler (ifidValue.instr, countIf, dpif.dhit, ihitEnable);
  
  hazard_unit hazard(countIf.dREN,jumpBranch, ifidValue.instr[25:21], ifidValue.instr[20:16], idexValue.dest, exmemValue.dest, stallPC, ifidFlush, idexFlush, ifidFreze);
  forwarding_unit forward(idexValue.instr[25:21], idexValue.instr[20:16], idexValue, exmemValue, memwbValue, memwbValueOld, rdat1Fwd, rdat2Fwd, r1Fwd, r2Fwd);


  assign dpif.imemREN = 1;
  assign dpif.dmemaddr = exmemValue.outputPort;
  assign ihitEnable = (~exmemValue.dREN && ~exmemValue.dWEN) && dpif.ihit;  
  assign memwbEnable = ihitEnable | dpif.dhit;
  assign exmemFlush = ~ihitEnable & dpif.dhit;
  assign dpif.dmemREN = exmemValue.dREN; // instead of request unit
  assign dpif.dmemWEN = exmemValue.dWEN; // instead of request unit
  assign ifidEnable = ihitEnable & ~ifidFreze;


  /********** Program Counter Update **********/
    assign dpif.imemaddr = pc;
    always_ff @(posedge CLK or negedge nRST) begin
      if (nRST == 0) begin
        pc <= PC_INIT;
      end
      else begin  
        if ((ihitEnable == 1) && (stallPC == 0)) begin
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
  assign rfif.wsel = memwbValue.dest;

  always_comb begin // wdat inputs
    if (memwbValue.lui == 1) 
      rfif.wdat = {memwbValue.instr[15:0],16'b0000000000000000};
    else begin
      if (memwbValue.jl == 1)
        rfif.wdat = memwbValue.pc +4;
      else begin
        if ((memwbValue.dREN == 1) || (memwbValue.ll == 1))
          rfif.wdat = memwbValue.dmemload;
        else 
          rfif.wdat = memwbValue.outputPort;
      end
    end
  end
  /********** Register Inputs **********/


  /********** Zero or Sign Extend Unit **********/
  always_comb begin
      if (idexValue.zeroExt == 0) begin // sign extend
        extendOut = {idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15],idexValue.instr[15:0]};
      end
      else begin // zero extend
        extendOut = {16'b0000000000000000,idexValue.instr[15:0]};
      end 
  end
  /********** Zero or Sign Extend Unit **********/


  /********** ALU Inputs **********/
  assign aluf.aluop = idexValue.aluOp;
  always_comb begin // setting port A
    if (r1Fwd == 1)
      aluf.portA = rdat1Fwd;
    else
      aluf.portA = idexValue.rdat1;
  end

  always_comb begin // setting port B
  	if (idexValue.shiftSel == 1)
  		aluf.portB = idexValue.instr[10:6];
  	else if (idexValue.aluSrc == 1) 
  		aluf.portB = extendOut;
  	else begin
      if (r2Fwd == 1)
        aluf.portB = rdat2Fwd;
      else
    		aluf.portB = idexValue.rdat2;
    end
  end
  /********** ALU Inputs **********/


  /********** Memory Write **********/
  assign dpif.dmemstore = exmemValue.rdat2;
  assign dpif.datomic = exmemValue.ll;
  always_comb begin
    if (r2Fwd == 1) 
        exmem_input.rdat2 = rdat2Fwd;
      else
        exmem_input.rdat2 = idexValue.rdat2;
  end
  /********** Memory Write **********/


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
