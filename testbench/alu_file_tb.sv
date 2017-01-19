/*
  Kyle Rakos
  krakos@purdue.edu

  ALU file test bench
*/

// mapped needs this
`include "alu_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_file_tb;

  parameter PERIOD = 10;
  parameter DELAY = 25;

  // interface
  alu_file_if aluf ();
  // test program
  test PROG (aluf);
  // DUT
  `ifndef MAPPED
  alu_file DUT(aluf);
  `else
  alu_file DUT(
    .\aluf.portA(aluf.portA),
    .\aluf.portB(aluf.portB),
    .\aluf.aluop(aluf.aluop),
    .\aluf.negative(aluf.negative),
    .\aluf.overflow(aluf.overflow),
    .\aluf.zero(aluf.zero),
    .\aluf.outputPort(aluf.outputPort)
    );
  `endif

endmodule

program test (
  alu_file_if.rf aluf
  );

import cpu_types_pkg::*;
int pass = 1'b1;
 parameter DELAY = 25;
    initial begin
    // Start
    aluf.aluop = ALU_SLL;
    aluf.portA = 32'b10100101010111101010110101100001;
    aluf.portB = 32'b00000000000000000000000000000010;
    #(DELAY);
    if (aluf.outputPort == (32'b10100101010111101010110101100001 << 32'b00000000000000000000000000000010))
      pass = 1'b1;
    else
      pass = 1'b0;
    #(DELAY);


    aluf.aluop = ALU_SRL;
    aluf.portA = 32'b10100101010111101010110101100001;
    aluf.portB = 32'b00000000000000000000000000000010;
    #(DELAY);
    if (aluf.outputPort == (32'b10100101010111101010110101100001 >> 32'b00000000000000000000000000000010))
      pass = 1'b1;
    else
      pass = 1'b0;
    #(DELAY);


    aluf.aluop = ALU_ADD;
    aluf.portA = 32'd45;
    aluf.portB = 32'd50;
    #(DELAY);
    if (aluf.outputPort == (45+50))
      pass = 1'b1;
    else
      pass = 1'b0;
    #(DELAY);


    aluf.aluop = ALU_SUB;
    aluf.portA = 32'd2;
    aluf.portB = 32'd2;
    #(DELAY);
    if (aluf.outputPort == (2-2))
      pass = 1'b1;
    else
      pass = 1'b0;
    #(DELAY);


    aluf.aluop = ALU_ADD;
    aluf.portA = 32'd1852516358;
    aluf.portB = 32'd1852516358;
    #(DELAY);
    if (aluf.overflow == 1)
      pass = 1'b1;
    else
      pass = 1'b0;
    
    #(DELAY);


    aluf.aluop = ALU_SUB;
    aluf.portA = 32'h80000000;
    aluf.portB = 32'd0294967290;
    #(DELAY);
    if (aluf.overflow == 1)
      pass = 1'b1;
    else
      pass = 1'b0;
    
    #(DELAY);


    aluf.aluop = ALU_AND;
    aluf.portA = 32'b10100101010111101010110101100001;
    aluf.portB = 32'b10111111001011110000011010101110;
    #(DELAY);
    if (aluf.outputPort == (32'b10100101010111101010110101100001 & 32'b10111111001011110000011010101110))
      pass = 1'b1;
    else
      pass = 1'b0;
    
    #(DELAY);


    aluf.aluop = ALU_OR;
    aluf.portA = 32'b10100101010111101010110101100001;
    aluf.portB = 32'b10111111001011110000011010101110;
    #(DELAY);
    if (aluf.outputPort == (32'b10100101010111101010110101100001 | 32'b10111111001011110000011010101110))
      pass = 1'b1;
    else
      pass = 1'b0;
    
    #(DELAY);


    aluf.aluop = ALU_XOR;
    aluf.portA = 32'b10100101010111101010110101100001;
    aluf.portB = 32'b10111111001011110000011010101110;
    #(DELAY);
    if (aluf.outputPort == (32'b10100101010111101010110101100001 ^ 32'b10111111001011110000011010101110))
      pass = 1'b1;
    else
      pass = 1'b0;
    
    #(DELAY);


    aluf.aluop = ALU_NOR;
    aluf.portA = 32'b10100101010111101010110101100001;
    aluf.portB = 32'b10111111001011110000011010101110;
    #(DELAY);
    if (aluf.outputPort == (32'b10100101010111101010110101100001 ~^ 32'b10111111001011110000011010101110))
      pass = 1'b1;
    else
      pass = 1'b0;
    
    #(DELAY);


    aluf.aluop = ALU_SLT;
    aluf.portA = 32'h80000000;
    aluf.portB = 32'd10;
    #(DELAY);
    if (aluf.outputPort == 1)
      pass = 1'b1;
    else
      pass = 1'b0;
    
    #(DELAY);


    aluf.aluop = ALU_SLTU;
    aluf.portA = 32'h80000000;
    aluf.portB = 32'd10;
    #(DELAY);
    if (aluf.outputPort == 0)
      pass = 1'b1;
    else
      pass = 1'b0;
    
    #(DELAY);

  end
endprogram
