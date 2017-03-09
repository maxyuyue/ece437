// data path interface
`include "pipe_reg_ifid_if.vh"
`include "cpu_types_pkg.vh"


module pipeRegIFID(
  input logic CLK, nRST, ihit,
  //two instances of the pipe_reg_if --> one as input and other as output
  pipe_reg_ifid_if prIFID_in,
  pipe_reg_ifid_if prIFID_out,
  input logic enable, flush
  );
  // import types
  import cpu_types_pkg::*;

  
  //write on positive edge of clock
  always_ff @(posedge CLK or negedge nRST) begin
  	if (nRST == 1'b0) begin   
      prIFID_out.aluOp = ALU_SLL;
      prIFID_out.instr = 32'h0;
      prIFID_out.incPC = 32'h0;
      prIFID_out.pc = 32'h0;
    end
    else if (flush == 1'b1 && ihit == 1'b1) begin // same as nRST
      prIFID_out.aluOp = ALU_SLL;
      prIFID_out.instr = 32'h0;
      prIFID_out.incPC = 32'h0;
      prIFID_out.pc = 32'h0;
    end
    else if (enable == 1) begin
      prIFID_out.aluOp = prIFID_in.aluOp;
      prIFID_out.instr = prIFID_in.instr;
      prIFID_out.incPC = prIFID_in.incPC;
      prIFID_out.pc = prIFID_in.pc;
    end
  end

endmodule