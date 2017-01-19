/*
  Kyle Rakos
  krakos@purdue.edu

  register_file.sv

  register file
  */

  `include "cpu_types_pkg.vh"
  `include "register_file_if.vh"

  module register_file
   
   (
    input logic CLK, nRST,
    register_file_if.rf rfif
    );
   import cpu_types_pkg::*;

   word_t regs [31:0];
   
   always_ff @(posedge CLK or negedge nRST) begin
    if (nRST == 0) begin
      regs <= '{default:'0};
    end
    else if (rfif.WEN) begin
      if (rfif.wsel != 0) begin
        regs[rfif.wsel] <= rfif.wdat;
      end	      
    end	   
  end

  always_comb begin
    rfif.rdat1 = regs[rfif.rsel1];
    rfif.rdat2 = regs[rfif.rsel2];

  end
  
endmodule
