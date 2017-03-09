
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
  logic isHit, isValid, lruBlock;

  //dcache
  cache_entry [7:0] [1:0] dcache, dcacheNext; // 8 sets and 2 blocks per set
  logic [7:0] lru, lruNext, hitCount, hitCountNext;
  typedef enum {IDLE, LOAD0, LOAD1, WRITE0, WRITE1, WB0, WB1, FLUSH0, HALT} state_type;
  typedef enum {NA,READ0HIT, READ1HIT, READ0MISSEMPTY, READ1MISSEMPTY,WRITE0HIT,WRITE1HIT,WRITE0MISSEMPTY,WRITE1MISSEMPTY,READMISSFULL, WRITEMISSFULL} debug;
  state_type state, stateNext;
  debug debugState;
  //query initializations
  assign query.tag = dcif.dmemaddr[31:6];
  assign query.idx = dcif.dmemaddr[5:3];
  assign query.blkoff = dcif.dmemaddr[2];
  assign query.bytoff = 2'b00;
  assign lruBlock = lru[query.idx];
  

  // State machine
  always_comb begin
    // Variable defaults
    dcacheNext = dcache;
    lruNext = lru;
    hitCountNext = hitCount;
    stateNext = IDLE;
    // DCIF defaults
    dcif.dhit = 0;  
    dcif.flushed = 0;
    // Cache default outputs
    cif.daddr = 32'hBAD1BAD1;
    cif.dstore = 32'hBAD1BAD1;
    dcif.dmemload = 32'hBAD1BAD1;
    cif.dREN = 0;
    cif.dWEN = 0;

    if (state == IDLE) begin
      if ((dcache[query.idx][0].tag == query.tag) && (dcache[query.idx][0].valid == 1) && (dcif.dmemREN == 1)) begin // hit loc 0 for read
        debugState = READ0HIT;
        dcif.dmemload = dcache[query.idx][0].data[query.blkoff]; // send value to datapath
        dcif.dhit = 1; // let datapath know ready for value
        lruNext[query.idx] = 1; // lru block now other block
        hitCountNext = hitCount + 1;
        stateNext = IDLE; // ready for next request
      end
      else if (dcache[query.idx][1].tag == query.tag && (dcache[query.idx][1].valid == 1)&& (dcif.dmemREN == 1)) begin // hit loc 1 for read
        debugState = READ1HIT;
        dcif.dmemload = dcache[query.idx][1].data[query.blkoff]; // send value to datapath
        dcif.dhit = 1; // let datapath know ready for value
        lruNext[query.idx] = 0; // lru block now other block
        hitCountNext = hitCount + 1;
        stateNext = IDLE; // ready for next request
      end
      else if ((dcache[query.idx][0].tag == query.tag) && (dcache[query.idx][0].valid == 1) && (dcif.dmemWEN == 1)) begin // hit loc 0 for write
        debugState = WRITE0HIT;
        dcacheNext[query.idx][0].data[query.blkoff] = dcif.dmemstore;
        dcif.dhit = 1;
        lruNext[query.idx] = 1; // lru block now other block
        dcacheNext[query.idx][0].dirty = 1; // block now dirty
        hitCountNext = hitCount + 1;
        stateNext = IDLE;
      end
      else if ((dcache[query.idx][1].tag == query.tag) && (dcache[query.idx][1].valid == 1) && (dcif.dmemWEN == 1)) begin // hit loc 1 for write
        debugState = WRITE1HIT;
        dcacheNext[query.idx][1].data[query.blkoff] = dcif.dmemstore;
        dcif.dhit = 1;
        lruNext[query.idx] = 0; // lru block now other block
        dcacheNext[query.idx][1].dirty = 1; // block now dirty
        hitCountNext = hitCount + 1;
        stateNext = IDLE;
      end

      else if ((dcache[query.idx][0].tag != query.tag) && (dcache[query.idx][0].valid != 1) && (dcif.dmemREN == 1)) begin // miss loc 0 for read. No prev data
        debugState = READ0MISSEMPTY;
        stateNext = LOAD0;
        lruNext[query.idx] = 0; // ensure block 0 is the one that is used
        hitCountNext = hitCount - 1;
      end
      else if ((dcache[query.idx][1].tag != query.tag) && (dcache[query.idx][1].valid != 1) && (dcif.dmemREN == 1)) begin // miss loc 1 for read. No prev data
        debugState = READ1MISSEMPTY;
        stateNext = LOAD0;
        lruNext[query.idx] = 1; // ensure block 1 is the one that is used
        hitCountNext = hitCount - 1;
      end
      else if ((dcache[query.idx][0].tag != query.tag) && (dcache[query.idx][0].valid != 1) && (dcif.dmemWEN == 1)) begin // miss loc 0 for write. No prev data
        debugState = WRITE0MISSEMPTY;
        stateNext = LOAD0;
        lruNext[query.idx] = 0; // ensure block 0 is the one that is used
        hitCountNext = hitCount - 1;
      end
      else if ((dcache[query.idx][1].tag != query.tag) && (dcache[query.idx][1].valid != 1) && (dcif.dmemWEN == 1)) begin // miss loc 0 for write. No prev data
        debugState = WRITE1MISSEMPTY;
        stateNext = LOAD0;
       lruNext[query.idx] = 1; // ensure block 1 is the one that is used
        hitCountNext = hitCount - 1;
      end


      else if ((dcache[query.idx][lruBlock].tag != query.tag) && (dcache[query.idx][lruBlock].valid == 1) && (dcif.dmemREN == 1)) begin // miss loc for read. Prev data
        debugState = READMISSFULL;
        stateNext = WB0;
        hitCountNext = hitCount - 1;
      end
      else if ((dcache[query.idx][lruBlock].tag != query.tag) && (dcache[query.idx][lruBlock].valid == 1) && (dcif.dmemWEN == 1)) begin // miss loc for write. Prev data
        debugState = WRITEMISSFULL;
        stateNext = WB0;
        hitCountNext = hitCount - 1;
      end
     

    end // end idle state

    else if (state == LOAD0) begin // load first word in block
      cif.daddr = {dcif.dmemaddr[31:3],3'b000};
      cif.dREN = 1;
      if (cif.dwait == 1) begin
        stateNext = LOAD0;
      end
      else begin
        dcacheNext[query.idx][lruBlock].tag = query.tag;
        dcacheNext[query.idx][lruBlock].data[0] = cif.dload;
        stateNext = LOAD1; // now time to load second word in block
      end
    end

    else if (state == LOAD1) begin // load second word in block
      cif.daddr = {dcif.dmemaddr[31:3],3'b100};
      cif.dREN = 1;
      if (cif.dwait == 1) begin
        stateNext = LOAD1;
      end
      else begin
        dcacheNext[query.idx][lruBlock].tag = query.tag;
        dcacheNext[query.idx][lruBlock].data[1] = cif.dload;
        dcacheNext[query.idx][lruBlock].valid = 1;
        dcacheNext[query.idx][lruBlock].dirty = 0;
        lruNext[query.idx] = ~lru[query.idx]; // lru block now other block
        stateNext = IDLE;
      end
    end


    else if (state == WB0) begin // load first word in block
      cif.daddr = {dcache[query.idx][lruBlock].tag, query.idx, 3'b000};
      cif.dstore = dcache[query.idx][lruBlock].data[0];
      cif.dWEN = 1;
      if (cif.dwait == 1) begin
        stateNext = WB0;
      end
      else begin
        stateNext = WB1; // now time to load second word in block
      end
    end

    else if (state == WB1) begin // load second word in block
      cif.daddr = {dcache[query.idx][lruBlock].tag, query.idx, 3'b100};
      cif.dstore = dcache[query.idx][lruBlock].data[1];
      cif.dWEN = 1;
      if (cif.dwait == 1) begin
        stateNext = WB1;
      end
      else begin
        dcacheNext[query.idx][lruBlock].valid = 0; // make not valid so it will be overwritten
        stateNext = IDLE;
      end
    end


    else begin
      stateNext = IDLE;
    end

  end


 always_ff @(posedge CLK, negedge nRST) begin
    if(nRST == 1'b0) 
      state = IDLE;
    else
      state = stateNext;
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
        lru[i] = '0;
        hitCount[i] = '0;
      end
    end
    else begin
      dcache <= dcacheNext;
      lru <= lruNext;
      hitCount <= hitCountNext;
    end

 	end


  endmodule // dcache
