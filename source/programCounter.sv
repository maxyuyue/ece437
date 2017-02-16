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
  input logic zero,
  control_if countIf,
  output word_t newPC, incPC, 
  output logic jumpBranch

);
  // import types
  import cpu_types_pkg::*;


	word_t	branchPC, mux1Out, mux2Out;
	logic branch, jump, jump2;

  // Mux 1
	always_comb begin
	  	if (countIf.bne == 1) begin // if a bne instruction
	  		if ((!zero && countIf.branch) == 1) begin // branch
	  			mux1Out = branchPC;
	  			branch = 1;
	  		end
	  		else begin // no branch
	  			mux1Out = incPC;
	  			branch = 0;
	  		end
	  	end
	  	else begin // Not a bne instruction
	  		if ((zero && countIf.branch) == 1) begin // branch
	  			mux1Out = branchPC;
	  			branch = 1;
	  		end
	  		else begin // no branch
	  			mux1Out = incPC;
	  			branch = 0;
	  		end
	  	end
	end

	// Mux 2
	always_comb begin
		if (countIf.jmpReg == 1) begin// select register 1 to jump to
			mux2Out = rdat1;
			jump = 1;
		end
		else begin // select mux1Out
			mux2Out = mux1Out;
			jump = 0;
		end
	end


	// Mux 3
	always_comb begin
		if (countIf.jmp == 1) begin// jump address
			newPC = {pc[31:26],(imemload[25:0] << 2)};
			jump2 = 1;
		end
		else begin // select mux2Out
			newPC = mux2Out;
			jump2 = 0;
		end
	end

  // Program counter connections
	assign incPC = pc + 4;
	assign branchPC = incPC + (extendOut << 2); 
	assign jumpBranch = jump | jump2 | branch;

endmodule
