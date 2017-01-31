/*
  Kyle Rakos

  Program counter module and associated logic to increment it

*/

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

`include "control_if.vh"

`include "register_file_if.vh"

import cpu_types_pkg::*;

module programCounter (
  input word_t pc, imemload, extendOut, rdat1,
  control_if contIf,
  output word_t newPC

);
  // import types
  import cpu_types_pkg::*;


	word_t	incPC, branchPC, mux1Out, mux2Out;



  // Mux 1
	always_comb begin
	  	if (contIf.bne == 1) begin // if a bne instruction
	  		if ((!contIf.zero && contIf.branch) == 1) begin // branch
	  			mux1Out = branchPC;
	  		end
	  		else begin // no branch
	  			mux1Out = incPC;
	  		end
	  	end
	  	else begin // Not a bne instruction
	  		if ((contIf.zero && contIf.branch) == 1) begin // branch
	  			mux1Out = branchPC;
	  		end
	  		else begin // no branch
	  			mux1Out = incPC;
	  		end
	  	end
	end

	// Mux 2
	always_comb begin
		if (contIf.jmpReg == 1) // select register 1 to jump to
			mux2Out = rdat1;
		else // select mux1Out
			mux2Out = mux1Out;
	end


	// Mux 3
	always_comb begin
		if (contIf.jmp == 1) // jump address
			newPC = {pc[31:26],(imemload[25:0] << 2)};
		else // select mux2Out
			newPC = mux2Out;
	end

  // Program counter connections
	assign incPC = pc + 4;
	assign branchPC = incPC + (extendOut << 2); 

endmodule
