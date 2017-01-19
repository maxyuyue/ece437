/*
  Kyle Rakos
  krakos@purdue.edu

  ALU File
  typedef enum logic [AOP_W-1:0] {
    ALU_SLL     = 4'b0000,
    ALU_SRL     = 4'b0001,
    ALU_ADD     = 4'b0010,
    ALU_SUB     = 4'b0011,
    ALU_AND     = 4'b0100,
    ALU_OR      = 4'b0101,
    ALU_XOR     = 4'b0110,
    ALU_NOR     = 4'b0111,
    ALU_SLT     = 4'b1010,
    ALU_SLTU    = 4'b1011
  } aluop_t;
*/

`include "cpu_types_pkg.vh"
`include "alu_file_if.vh"

module alu_file
   
   (
    alu_file_if.rf aluf
   );
   import cpu_types_pkg::*;

   always_comb begin

    // output port 
    casez (aluf.aluop) 
      ALU_SLL  : begin
        aluf.outputPort = aluf.portA << aluf.portB;
      end
      ALU_SRL  : begin
        aluf.outputPort = aluf.portA >> aluf.portB;
      end
      ALU_ADD  : begin
        aluf.outputPort = aluf.portA + aluf.portB;
      end
      ALU_SUB  : begin
        aluf.outputPort = aluf.portA - aluf.portB;
      end
      ALU_AND  : begin
        aluf.outputPort = aluf.portA & aluf.portB;
      end
      ALU_OR   : begin
        aluf.outputPort = aluf.portA | aluf.portB;
      end
      ALU_XOR  : begin
        aluf.outputPort = aluf.portA ^ aluf.portB;
      end
      ALU_NOR  : begin
        aluf.outputPort = aluf.portA ~^ aluf.portB;
      end
      ALU_SLT  : begin
        if (signed'(aluf.portA) < signed'(aluf.portB)) 
          aluf.outputPort = 1;
        else
          aluf.outputPort = 0;
      end
      ALU_SLTU : begin
        if (unsigned'(aluf.portA) < unsigned'(aluf.portB)) 
          aluf.outputPort = 1;
        else
          aluf.outputPort = 0;
      end
    endcase


    // Negative flag
    if (signed'(aluf.outputPort) < 0)
      aluf.negative = 1'b1;
    else
      aluf.negative = 1'b0;

    // Zero flag
    if (aluf.outputPort == 0) 
      aluf.zero = 1'b1;
    else
      aluf.zero = 1'b0;

    // Overflow flag
    if ((aluf.aluop == ALU_ADD) && (aluf.portA[31] == aluf.portB[31]) && (aluf.portA[31] != aluf.outputPort[31]))
      aluf.overflow = 1'b1;
    else if ((aluf.aluop == ALU_SUB) && (aluf.portA[31] != aluf.portB[31]) && (aluf.portA[31] != aluf.outputPort[31]))
      aluf.overflow = 1'b1;
    else
      aluf.overflow = 1'b0;

end
   
endmodule
