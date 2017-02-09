// data path interface
`include "pipe_reg_if.vh"
`include "cpu_types_pkg.vh"


module pipeRegIFID(
  input logic CLK, nRST,
  //two instances of the pipe_reg_if --> one as input and other as output
  pipe_reg_if prIFID_in,
  pipe_reg_if prIFID_out,
  input logic enable, flush
  );
  // import types
  import cpu_types_pkg::*;

  
  //write on positive edge of clock
  always_ff @(posedge CLK or negedge nRST) begin
  	if (nRST == 0 || flush == 1) 
    begin	  
      prIFID_out.regDst = 0;
      prIFID_out.branch = 0;
      prIFID_out.WEN = 0;
      prIFID_out.aluSrc = 0;
      prIFID_out.jmp = 0;
      prIFID_out.jl = 0;
      prIFID_out.jmpReg = 0;
      prIFID_out.memToReg = 0;
      prIFID_out.dREN = 0;
      prIFID_out.dWEN = 0;
      prIFID_out.lui = 0;
      prIFID_out.bne = 0;
      prIFID_out.zeroExt = 0;
      prIFID_out.shiftSel = 0;
      prIFID_out.aluCont = 0;
      prIFID_out.aluOp = 0;
      prIFID_out.instr = 32'h0;
      prIFID_out.incPC = 32'h0;
      prIFID_out.pc = 32'h0;
      prIFID_out.rdat1 = 32'h0;
      prIFID_out.rdat2 = 32'h0;
      prIFID_out.outputPort = 32'h0;
    end
  end


  always_ff @(negedge CLK) 
  begin
    if(enable) 
    begin
     prIFID_out.regDst = prIFID_in.regDst;
     prIFID_out.branch = prIFID_in.branch;
     prIFID_out.WEN = prIFID_in.WEN;
     prIFID_out.aluSrc = prIFID_in.aluSrc;
     prIFID_out.jmp = prIFID_in.jmp;
     prIFID_out.jl = prIFID_in.jl;
     prIFID_out.jmpReg = prIFID_in.jmpReg;
     prIFID_out.memToReg = prIFID_in.memToReg;
     prIFID_out.dREN = prIFID_in.dREN;
     prIFID_out.dWEN = prIFID_in.dWEN;
     prIFID_out.lui = prIFID_in.lui;
     prIFID_out.bne = prIFID_in.bne;
     prIFID_out.zeroExt = prIFID_in.zeroExt;
     prIFID_out.shiftSel = prIFID_in.shiftSel;
     prIFID_out.aluCont = prIFID_in.aluCont;
     prIFID_out.aluOp = prIFID_in.aluOp;
     prIFID_out.instr = prIFID_in.instr;
     prIFID_out.incPC = prIFID_in.incPC;
     prIFID_out.pc = prIFID_in.pc;
     prIFID_out.rdat1 = prIFID_in.rdat1;
     prIFID_out.rdat2 = prIFID_in.rdat2;
     prIFID_out.outputPort = prIFID_in.outputPort;    
   end
 end
endmodule