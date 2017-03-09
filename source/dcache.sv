
// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
// import types
import cpu_types_pkg::*;  


module dcache (
  input logic CLK, nRST,
  datapath_cache_if.dcache dcif,
  caches_if.dcache cif
);
  
typedef struct packed {
  logic [25:0]  tag;
  word_t data;
  logic valid;
  logic dirty;
} cache_entry;

  dcachef_t query;
  logic isHit, isValid;

  //dcache
  cache_entry [15:0] [1:0] dcache;

  //query initializations
  assign query.tag = dcif.imemaddr[31:6];
  assign query.idx = dcif.imemaddr[5:3];
  assign query.blkoff = dcif.imemaddr[2];
  assign query.bytoff = 2'b00;

  

  // State machine
  always_comb begin
    //isHit = dcache[query.idx].tag == query.tag;
    //isValid = dcache[query.idx].v;
  end

  integer i, x;

  always_ff @(posedge CLK, negedge nRST) begin
    if(nRST == 1'b0) begin
      for(i = 0; i < 16; i++) begin
        for (x = 0; x < 2; x++) begin
          dcache[x][i].tag <= '0;
          dcache[x][i].data <= '0;
          dcache[x][i].valid <= 0;
          dcache[x][i].dirty <= 0;
        end
      end
    end
    /*else if(~cif.iwait && dcif.imemREN)
      begin
        dcache[query.idx].data <= cif.iload;
        dcache[query.idx].tag <= query.tag;
        dcache[query.idx].v <= 1;
      end*/
 	end
/*
  always_comb
		begin
      dcif.ihit = 0;
      cif.iREN = 0;
      cif.iaddr = 0;

      if(isValid && isHit && dcif.imemREN) //Query found in cache
        begin
          dcif.ihit = 1;
        end
      else  //fetch value from memory
        begin
          cif.iREN = dcif.imemREN;
          cif.iaddr = dcif.imemaddr;
        end
		end

   assign dcif.imemload = cif.iload; 
*/
  endmodule // dcache
