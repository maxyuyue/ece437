/*
  Kyle Rakos
  krakos@purdue.edu

  Request Unit
*/

  // data path interface
`include "cpu_types_pkg.vh"

  import cpu_types_pkg::*;

  module requestUnit 
    (
      input logic CLK, nRST, dREN, dWEN, ihit, dhit, 
      output logic dmemREN, dmemWEN
    );


always_ff @(posedge CLK or negedge nRST) begin
      if (nRST == 0) begin
        dmemREN = 0;
        dmemWEN = 0;
      end
      else begin  
        if (ihit == 1) begin // Instruction loaded, now do data
          dmemREN = dREN;
          dmemWEN = dWEN;
        end
        else if (dhit == 1) begin // Finished data read, now allow instruction read
          dmemREN = 0;
          dmemWEN = 0;
        end
      end    
    end



endmodule
