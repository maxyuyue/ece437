/*
  Kyle Rakos
  krakos@purdue.edu

  register_file_tb.sv

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG (CLK,rfif,nRST);
  // DUT
  `ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
  `else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
    );
  `endif

endmodule

program test (
  input logic  CLK,
  register_file_if.rf rfif,
  output logic nRST
  );
    parameter PERIOD = 10;

    initial begin
    // Initialization
    nRST = 0;
    rfif.wsel = 5'h00;
    rfif.wdat = 32'h00000000;
    rfif.WEN = 0;
    rfif.rsel1 = 5'h0;
    rfif.rsel2 = 5'h0; 
    @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK);

    // Write value to reg 1
    nRST = 1;
    rfif.wsel = 5'h01;
    rfif.wdat = 32'hfedcba98;
    rfif.WEN = 1;
    rfif.rsel1 = 5'h0;
    @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK);

    // Write value to reg 31
    nRST = 1;
    rfif.wsel = 5'd31;
    rfif.wdat = 32'h89abcdef;
    rfif.WEN = 1;
    rfif.rsel1 = 5'h0;
    rfif.rsel2 = 5'd31;
    @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK);


  // Write value to reg 25 without write enable
    nRST = 1;
    rfif.wsel = 5'd25;
    rfif.wdat = 32'hbbbbbbbb;
    rfif.WEN = 0;
    rfif.rsel1 = 5'd25;
    rfif.rsel2 = 5'd31;
    @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK);

    // Write value to reg 25 with write enable
    nRST = 1;
    rfif.wsel = 5'd25;
    rfif.wdat = 32'hbbbbbbbb;
    rfif.WEN = 1;
    rfif.rsel1 = 5'd25;
    rfif.rsel2 = 5'd31;
    @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK);

    // Write value to reg 24 without initially showing it
    nRST = 1;
    rfif.wsel = 5'd24;
    rfif.wdat = 32'hcccccccc;
    rfif.WEN = 1;
    rfif.rsel1 = 5'd25;
    rfif.rsel2 = 5'd31;
    @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK);

  // Show reg 24
     nRST = 1;
    rfif.wsel = 5'd24;
    rfif.wdat = 32'h00000000;
    rfif.WEN = 0;
    rfif.rsel1 = 5'd24;
    rfif.rsel2 = 5'd31;
    @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK);

  // Reset
    nRST = 0;
    rfif.wsel = 5'd00;
    rfif.wdat = 32'haaaaaaaa;
    rfif.WEN = 0;
    rfif.rsel1 = 5'd24;
    rfif.rsel2 = 5'd31;
    @(posedge CLK); @(posedge CLK); @(posedge CLK); @(posedge CLK);


    end


endprogram
