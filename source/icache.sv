
// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
// import types
import cpu_types_pkg::*;  


module icache (
  input logic CLK, nRST,
  datapath_cache_if.icache dcif,
  caches_if.icache cif
);
  
typedef struct packed {
  logic [25:0]  tag;
  word_t data;
  logic v;
} cache_entry;

  icachef_t query;
  logic isHit, isValid;

  //icache
  cache_entry [15:0] icache;

  //query initializations
  assign query.tag = dcif.imemaddr[31:6];
  assign query.idx = dcif.imemaddr[5:2];
  assign isHit = icache[query.idx].tag == query.tag;
  assign isValid = icache[query.idx].v;

  integer i;

  always_ff @(posedge CLK, negedge nRST)
  	begin
      if(!nRST)
        begin
          for(i = 0; i < 16; i++)
            begin
              icache[i].tag <= '0;
              icache[i].data <= '0;
              icache[i].v <= 0;
            end
        end
      else if(~cif.iwait && dcif.imemREN)
        begin
          icache[query.idx].data <= cif.iload;
          icache[query.idx].tag <= query.tag;
          icache[query.idx].v <= 1;
        end
 		end

  always_comb
		begin
      dcif.ihit = 0;
      if(isValid && isHit && dcif.imemREN) //Query found in cache
        begin
          dcif.ihit = 1;
        end
		end

   assign cif.iREN = dcif.imemREN && ~dcif.ihit; //and not  ihit
   assign cif.iaddr = dcif.imemaddr;
   assign dcif.imemload = icache[query.idx].data; 

  endmodule // icache
