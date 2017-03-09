
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
  word_t [1:0] data;
  logic valid;
  logic dirty;
} cache_entry;

  dcachef_t query;
  logic isHit, isValid;

  //dcache
  cache_entry [7:0] [1:0] dcache, dcacheNext; // 8 sets and 2 blocks per set
  logic [2:0] lastUsed;
  typedef enum {IDLE, LOAD0, LOAD1, WRITE0, WRITE1, WB, FLUSH0, HALT} state_type;
  state_type state, nextState;

  //query initializations
  assign query.tag = dcif.dmemaddr[31:6];
  assign query.idx = dcif.dmemaddr[5:3];
  assign query.blkoff = dcif.dmemaddr[2];
  assign query.bytoff = 2'b00;

  

  // State machine
  always_comb begin
    dcacheNext = dcache;
    if (state == IDLE) begin
      dcif.dhit = 0;
      dcif.dmemload = '0;

      if ((dcache[query.idx][0].tag == query.tag) && (dcache[query.idx][0].valid == 1) && (dcif.dmemREN == 1)) begin // hit loc 0 for read
        dcif.dmemload = dcache[query.idx][0].data[query.blkoff];
        dcif.dhit = 1;
        nextState = IDLE;
      end
      else if (dcache[query.idx][1].tag == query.tag && (dcache[query.idx][1].valid == 1)) begin // hit loc 1 for read
        dcif.dmemload = dcache[query.idx][1].data[query.blkoff];
        dcif.dhit = 1;
        nextState = IDLE;
      end
      else if ((dcache[query.idx][0].tag == query.tag) && (dcache[query.idx][0].valid == 1) && (dcif.dmemWEN == 1)) begin // hit loc 0 for write
        //dcache[query.idx][0].data[query.blkoff] = dcif.dmemstore;
        dcif.dhit = 1;
        nextState = IDLE;
      end
      else if ((dcache[query.idx][1].tag == query.tag) && (dcache[query.idx][1].valid == 1) && (dcif.dmemWEN == 1)) begin // hit loc 1 for write
        //dcache[query.idx][1].data[query.blkoff] = dcif.dmemstore;
        dcif.dhit = 1;
        nextState = IDLE;
      end

      else if ((dcache[query.idx][0].tag != query.tag) && (dcache[query.idx][0].valid != 1) && (dcif.dmemREN == 1)) begin // miss loc 0 for read. No prev data
        nextState = LOAD0;
      end
      else if ((dcache[query.idx][1].tag != query.tag) && (dcache[query.idx][1].valid != 1) && (dcif.dmemREN == 1)) begin // miss loc 1 for read. No prev data
        nextState = LOAD1;
      end
      else if ((dcache[query.idx][0].tag != query.tag) && (dcache[query.idx][0].valid != 1) && (dcif.dmemWEN == 1)) begin // miss loc 0 for write. No prev data
        nextState = WRITE0;
      end
      else if ((dcache[query.idx][0].tag != query.tag) && (dcache[query.idx][0].valid != 1) && (dcif.dmemWEN == 1)) begin // miss loc 0 for write. No prev data
        nextState = WRITE1;
      end
    end // end idle state

    else if (state == WRITE0) begin
      cif.daddr = dcif.dmemaddr;
      cif.dWEN = dcif.dmemWEN;
      if (cif.dwait == 1) begin
        dcif.dhit = 0;
        nextState = WRITE0;
      end
      else begin
        dcif.dhit = 1;
        dcacheNext[query.idx][0].tag = query.tag;
        dcacheNext[query.idx][0].data[query.blkoff] = cif.dload;
        dcacheNext[query.idx][0].valid = 1;
        dcacheNext[query.idx][0].dirty = 0;
        nextState = IDLE;
      end
    end // end write0 state

    else begin
      nextState = IDLE;
    end

  end


 always_ff @(posedge CLK, negedge nRST) begin
    if(nRST == 1'b0) 
      state = IDLE;
    else
      state = nextState;
 end
 

 integer i, x;
  always_ff @(posedge CLK, negedge nRST) begin
    if(nRST == 1'b0) begin
      for(i = 0; i < 8; i++) begin
        for (x = 0; x < 2; x++) begin
          dcache[i][x].tag <= '0;
          dcache[i][x].data[0] <= '0;
          dcache[i][x].data[1] <= '0;
          dcache[i][x].valid <= 0;
          dcache[i][x].dirty <= 0;
        end
      end
    end
    else begin
      dcache <= dcacheNext;
    end
    /*
    else if ((state == WRITE0) && (~cif.dwait)) begin // received data, now write
      dcache[query.idx][0].tag = query.tag;
      dcache[query.idx][0].data[query.blkoff] = cif.dload;
      dcache[query.idx][0].valid = 1;
      dcache[query.idx][0].dirty = 0;
    end
  */
    //else if ((state == IDLE) && (dcif.dhit == 1) && (dcif.dmemWEN == 1) && ) // write to block that was just hit
    
    /*else if(~cif.dwait && (dcif.dREN || dcif.dWEN)) begin // Update cache from RAM 
      dcache[query.idx].tag <= query.tag;
      dcache[query.idx].data <= cif.iload;
      dcache[query.idx].valid <= 1;
      dcache[i][x].dirty <= 0;
    end*/
 	end


  endmodule // dcache
