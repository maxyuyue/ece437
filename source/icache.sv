
// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

module caches (
  input logic CLK, nRST,
  datapath_cache_if.cache dcif,
  caches_if.caches cif
);
  // import types
  import cpu_types_pkg::word_t;

  logic Hit;

  typedef enum bit {MISS,IDLE} state_t;
  state_t state, nxtstate;


  always_ff @(posedge CLK, negedge nRST)
  	begin

 		end

  always_comb
		begin
			case(state)
				IDLE:
					begin

					end

				MISS:
					begin

					end
			endcase // state
		end
