
// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"

module icache (
  input logic CLK, nRST,
  datapath_cache_if.cache dcif,
  caches_if.caches cif
);
  // import types
  import cpu_types_pkg::word_t;

  logic[31:0] instr, new_instr;
  icachef_t query;
  logic isHit, isValid;

  //icache
  icachef_t[15:0] info; //tag, index and byte offset
  logic[15:0] valid_bit;  //valid bit for each slot
  logic[15:0][31:0] data; //data in each slot


  //query initializations
  assign query.tag = dcif.imemaddr[31:6];
  assign query.idx = dcif.imemaddr[5:2];
  assign isHit = info[query.idx].tag == query.tag;
  assign isValid = valid_bit[query.idx];

  integer i;

  always_ff @(posedge CLK, negedge nRST)
  	begin
      if(!nRST)
        begin
          instr <= 32b'0;
          for(i = 0; i < 16; i++)
            begin
              valid_bit[i] <= 0;
            end
        end
      else
        begin
          instr <= new_instr;
        end
 		end

  always_comb
		begin
			new_instr = instr;
      dcif.ihit = 0;
      dcif.imemload = 0;
      cif.iREN = 0;
      cif.iaddr = 0;

      if(isValid && isHit) //Query found in cache
        begin
          dcif.imemload = data[query.idx];
          dcif.ihit = 1;
          new_instr = data[query.idx];
        end
      else  //fetch value from memory
        begin
          cif.iREN = dcif.imemREN;
          cif.iaddr = dcif.imemaddr;
          if(~cif.iwait)
            begin
              valid_bit[query.idx] = 1;
              data[query.idx] = cif.iload;
              info[query.idx].tag = query.tag;
              info[query.idx].idx = query.idx;
              dcif.ihit = 1;
              dcif.imemload = cif.iload;
              new_instr = cif.iload;
            end
          else
            begin
              dcif.imemload = instr;
            end
        end
		end
  endmodule // icache
