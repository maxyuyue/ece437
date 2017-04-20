/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

typedef enum {IDLE, WRITE_M0, WRITE_M1, SNOOP, LOAD0, LOAD1, WRITE0, WRITE1, INSTR}state_type;   
state_type state, nxt_state;
  /*
    ccif.iwait: 1 when no instruction to load and/or not access busy, 0 otherwise ->
    ccif.dwait: 1 when no data to load/write and/or not access busy, 0 otherwise ->
    ccif.iREN: 1 when ask to read(load) instruction, 0 otherwise <-
    ccif.dREN: 1 when ask to read(load) data, 0 otherwise <-
    ccif.dWEN: 1 when ready to write data, 0 otherwise <-
    ccif.iload: instruction to return to cache (32) ->
    ccif.dload: data to return to cache (32) ->
    ccif.dstore: data to write to RAM (32) <-
    ccif.iaddr: address to load instruction from (32) <-
    ccif.daddr: address to write/load data from (32) <- 

    ccif.ramWEN: 1 when requesting to write data, 0 otherwise ->
    ccif.ramREN: 1 when requesting to read(load) instruction or data, 0 otherwise ->
    ccif.ramstate: Indicates current state of RAM as either FREE, BUSY, ACCESS, or ERROR <-
    ccif.ramaddr: Address to load/write from (32) ->
    ccif.ramstore: Data to write (32) ->
    ccif.ramload: Data returned from RAM (32) <-

    // coherence
      CPUS = number of cpus parameter passed from system -> cc
      ccwait         : lets a cache know it needs to block cpu
      ccinv          : let a cache know it needs to invalidate entry
      ccwrite        : high if cache is doing a write of addr
      ccsnoopaddr    : the addr being sent to other cache with either (wb/inv)
      cctrans        : high if the cache state is transitioning (i.e. I->S, I->M, etc...)

  */

logic[1:0] ccinv, nxt_ccinv;
logic[1:0] ccwait;
word_t[1:0] snoopaddr, nxt_snoopaddr;
logic serviced, nxt_serviced;
logic lru, nlru; //used to service the least recently used icache
logic i, nxt_i; //index of i cache to be serviced


always_ff @(posedge CLK or negedge nRST)
  begin
    if(~nRST)
      begin
        state <= IDLE;
        ccinv[0] <= 0;
        ccinv[1] <= 0;
        snoopaddr[0] <= '0;
        snoopaddr[1] <= '0;
        //ccwait[0] <= 0;
        //ccwait[1] <= 0;
        serviced <= 0;
        lru <= 0;
        i <= 0;
      end 
    else
     begin
      state <= nxt_state;
      ccinv[0] <= nxt_ccinv[0];
      ccinv[1] <= nxt_ccinv[1];
      snoopaddr[0] <= nxt_snoopaddr[0];
      snoopaddr[1] <= nxt_snoopaddr[1];
      serviced <= nxt_serviced;
      lru <= nlru;
      i <= nxt_i;
    end
end


always_comb begin

    ccif.ramaddr = '0;
    ccif.ramstore = '0;
    ccif.ramWEN = 0;
    ccif.ramREN = 0;

    ccif.dload[0] = ccif.ramload;
    ccif.iload[0] = ccif.ramload;
    ccif.dload[1] = ccif.ramload;
    ccif.iload[1] = ccif.ramload;

    ccif.iwait[0] = 1;
    ccif.iwait[1] = 1;
    ccif.dwait[0] = 1;    
    ccif.dwait[1] = 1;

    nxt_ccinv[0] = ccinv[0];
    nxt_ccinv[1] = ccinv[1];
    nxt_snoopaddr[0] = snoopaddr[0];
    nxt_snoopaddr[1] = snoopaddr[1];

    nxt_serviced = serviced;
    nlru = lru;
    nxt_i = i;

    nxt_state = state;
    ccwait[0] = 1'b0;
    ccwait[1] = 1'b0;

    case (state)
      IDLE:
        begin
          nxt_ccinv[0] = 0;
          nxt_ccinv[1] = 0;          
          ccwait[0] = 1'b0;
          ccwait[1] = 1'b0;
          nxt_snoopaddr[0] = 32'hBAD1BAD1;
          nxt_snoopaddr[1] = 32'hBAD1BAD1;
          if(ccif.dWEN[0] && ~ccif.cctrans[0]) // 
            begin
              nxt_state = WRITE_M0;
              nxt_serviced = 0;
            end

          else if(ccif.cctrans[0])
            begin
              nxt_serviced = 0;
              nxt_snoopaddr[1] = ccif.daddr[0]; 
              nxt_state = SNOOP;
            end 

          else if(ccif.dWEN[1] && ~ccif.cctrans[1])
            begin
              nxt_state = WRITE_M0;
              nxt_serviced = 1;
            end  
            
          else if(ccif.cctrans[1])
            begin
              nxt_serviced = 1;
              nxt_snoopaddr[0] = ccif.daddr[1]; 
              nxt_state = SNOOP;
            end

          else if(ccif.iREN[0] || ccif.iREN[1])
            begin
              if(ccif.iREN[0] && ccif.iREN[1])
                begin
                  nlru = ~lru;
                  nxt_i = lru;
                end
              else
                begin
                  nlru = (ccif.iREN[0] == 1) ? 1 : 0;
                  nxt_i = (ccif.iREN[0] == 1) ? 0 : 1;
                end
              nxt_state = INSTR;
            end

          else
            begin
              nxt_state = IDLE;
            end

        end

      WRITE_M0:
        begin
          nxt_ccinv[0] = 0;
          nxt_ccinv[1] = 0;
          ccwait[~serviced] = 1'b1;
          ccwait[serviced] = 1'b0;
          ccif.ramWEN = 1;
          ccif.ramstore = ccif.dstore[serviced];
          ccif.ramaddr = ccif.daddr[serviced];
          if(ccif.ramstate != ACCESS)
            begin
              nxt_state = WRITE_M0;
            end
          else
            begin
              ccif.dwait[serviced] = 0;
              nxt_state = WRITE_M1;
            end
        end


      WRITE_M1:
        begin
          nxt_ccinv[0] = 0;
          nxt_ccinv[1] = 0;          
          ccif.ramWEN = 1;
          ccif.ramstore = ccif.dstore[serviced];
          ccif.ramaddr = ccif.daddr[serviced];
          if(ccif.ramstate != ACCESS) begin
            ccwait[~serviced] = 1'b1;
            ccwait[serviced] = 1'b0;
            nxt_state = WRITE_M1;
          end
          else
            begin
              ccif.dwait[serviced] = 0;
              ccwait[~serviced] = 1'b0;
              ccwait[serviced] = 1'b0;
              nxt_state = IDLE;
            end
        end

      SNOOP:
        begin          
          ccwait[~serviced] = 1'b1;
          ccwait[serviced] = 1'b0;
          if(ccif.cctrans[~serviced]) begin // if nonserviced cache is transfering
            if(~ccif.ccwrite[~serviced]) begin // if nonservice write is 0
              nxt_state = LOAD0;
              if(ccif.cctrans[serviced] && ccif.ccwrite[serviced]) begin // if serviced cache is transfering and writing
                nxt_ccinv[~serviced] = 1; // invalidate nonservice cache
              end
            end
            else if(ccif.ccwrite[~serviced]) begin // if nonservice cache is writing
              nxt_state = WRITE0;
              if(ccif.cctrans[serviced] && ccif.ccwrite[serviced]) begin
                nxt_ccinv[~serviced] = 1;                  
              end
            end
            else begin
              nxt_state = SNOOP;
            end
          end
          else begin
              nxt_state = SNOOP;
          end
        end

      LOAD0:
        begin
          ccwait[~serviced] = 1'b1;
          ccwait[serviced] = 1'b0;
          ccif.ramREN = 1;
          ccif.ramaddr = ccif.daddr[serviced];
          if(ccif.ramstate != ACCESS)
            begin
              nxt_state = LOAD0;
              ccwait[~serviced] = 1'b1;
              ccwait[serviced] = 1'b0;
            end
          else
            begin
              ccif.dwait[serviced] = 0;
              ccif.dload[serviced] = ccif.ramload;
              nxt_state = LOAD1;
            end
        end

      LOAD1:
        begin
          
          ccif.ramREN = 1;
          ccif.ramaddr = ccif.daddr[serviced];
          if(ccif.ramstate != ACCESS)
            begin
              nxt_state = LOAD1;
              ccwait[~serviced] = 1'b1;
              ccwait[serviced] = 1'b0;
            end
          else
            begin
              ccif.dwait[serviced] = 0;
              ccif.dload[serviced] = ccif.ramload;
              ccwait[~serviced] = 1'b0;
              ccwait[serviced] = 1'b0;
              nxt_state = IDLE;
            end
        end

      WRITE0:
        begin
          ccwait[~serviced] = 1'b1;
          ccwait[serviced] = 1'b0;
          ccif.ramWEN = 1;
          ccif.ramstore = ccif.dstore[~serviced];
          ccif.ramaddr = ccif.daddr[~serviced];
          if(ccif.ramstate != ACCESS)
            begin
              nxt_state = WRITE0;
            end
          else
            begin
              ccif.dwait[serviced] = 0;
              ccif.dwait[~serviced] = 0;
              ccif.dload[serviced] = ccif.dstore[~serviced];
              nxt_state = WRITE1;
            end
        end

      WRITE1:
        begin
          ccif.ramWEN = 1;
          ccif.ramstore = ccif.dstore[~serviced];
          ccif.ramaddr = ccif.daddr[~serviced];
          if(ccif.ramstate != ACCESS)
            begin
              nxt_state = WRITE1;
              ccwait[~serviced] = 1'b1;
              ccwait[serviced] = 1'b0;
            end
          else
            begin
              ccif.dwait[serviced] = 0;
              ccif.dload[serviced] = ccif.dstore[~serviced];
              ccif.dwait[~serviced] = 0;
              
              nxt_state = IDLE;
              ccwait[~serviced] = 1'b0;
              ccwait[serviced] = 1'b0;
            end
        end 

      INSTR:
        begin
          nxt_ccinv[0] = 0;
          nxt_ccinv[1] = 0;
          ccwait[0] = 1'b0;
          ccwait[1] = 1'b0;
          ccif.ramREN = 1;
          ccif.ramaddr = ccif.iaddr[i];
          if(ccif.ramstate != ACCESS)
            begin
              nxt_state = INSTR;
            end
          else
            begin
              ccif.iwait[i] = 0;
              nxt_state = IDLE;
            end
        end
    
      default : /* default */;
    endcase
  end

  assign ccif.ccwait[0] = ccwait[0];
  assign ccif.ccwait[1] = ccwait[1];
  assign ccif.ccinv[0] = ccinv[0];
  assign ccif.ccinv[1] = ccinv[1];
  assign ccif.ccsnoopaddr[0] = snoopaddr[0];
  assign ccif.ccsnoopaddr[1] = snoopaddr[1];

endmodule // coherence_controller 