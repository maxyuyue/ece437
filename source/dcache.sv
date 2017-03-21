
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
  logic isHit1, isHit2;

  //Values used to update cache in always_ff block
  logic lru_nxt, valid_nxt, dirty_nxt;
  word_t data_nxt;
  //index of table to update
  logic tab_index; 
  //block offset used in LOAD0, LOAD1 states
  logic offset;
  //counter variable used in the flush state
  logic[3:0] count, nxt_count;
  //hitCount
  word_t hitCount, hitCount_nxt, missCount, missCount_nxt;

//dcache
cache_entry [1:0][7:0] dcache; //8 sets and 2 blocks per set
logic[7:0] lru;	
typedef enum {IDLE, LOAD0, LOAD1, WRITE0, WRITE1, WB0_FLUSH0, WB1_FLUSH0, WB0_FLUSH1, WB1_FLUSH1, FLUSH0, FLUSH1, HALT} state_type;	
/*State descriptions
LOAD0 - Read word one from memory in case of a miss
LOAD1 - Read word two from memory in case of a miss
WRITE0 - Write word one to memory in case of a miss and dirty bit high
WRITE1 - Write word two to memory in case of a miss and dirty bit high
WB0 - Write back word one (done after halt is received)
WB1 - Write back word two (done after halt is received)
FLUSH0 - Flush registers after receiving halt
HALT - Halt signal received
*/

state_type state, nxt_state;

//query initializations
assign query.tag = dcif.dmemaddr[31:6];
assign query.idx = dcif.dmemaddr[5:3];
assign query.blkoff = dcif.dmemaddr[2];
assign query.bytoff = 2'b00;
assign lruBlock = lru[query.idx];

//Hit initializations
assign isHit1 = (dcache[0][query.idx].tag == query.tag && dcache[0].valid == 1) ? 1 : 0;
assign isHit2 = (dcache[1][query.idx].tag == query.tag && dcache[1].valid == 1) ? 1 : 0;

always_ff @(posedge CLK, negedge nRST)
	begin
    if(nRST == 1'b0) 
      state = IDLE;
    else
      state = nxt_state;
 end
 

integer i, x;
always_ff @(posedge CLK, negedge nRST)
	begin
    if(nRST == 1'b0)
    	begin
    		count <= 0;
    		hitCount <= 0;
    		missCount <= 0;
	      for(i = 0; i < 8; i++) 
	      	begin
	        	for (x = 0; x < 2; x++)
	        		begin
		          	dcache[i][x].tag <= '0;
			          dcache[i][x].data[0] <= '0;
			          dcache[i][x].data[1] <= '0;
			          dcache[i][x].valid <= 0;
			          dcache[i][x].dirty <= 0;
      	  		end
        	lru[i] = '0;
      		end
    	end
    else
    	begin
      	lru[query.idx] <= lru_nxt;
      	dcache[tab_index][query.idx].data[offset] <= data_nxt;
      	dcache[tab_index][query.idx].valid <= valid_nxt;
      	dcache[tab_index][query.idx].dirty <= dirty_nxt;
      	count <= nxt_count;
      	hitCount <= hitCount_nxt;
      	missCount <= missCount_nxt;
    	end
 	end


//State machine
always_comb
	begin
		nxt_state = state;
    
    // DCIF 
    dcif.dhit = 0;  
    dcif.flushed = 0;
    dcif.dmemload = 32'hBAD1BAD1;

    // CIF default outputs
    cif.daddr = 32'hBAD1BAD1;
    cif.dstore = 32'hBAD1BAD1;
    cif.dREN = 0;
    cif.dWEN = 0;

    //index of the table used, out of the two tables in dcache
    tab_index = lru[query.idx];
    
    //dcache update values
    lru_nxt = lru[query.idx];
    data_nxt = dcache[tab_index][query.idx].data[query.blkoff];
    valid_nxt = dcache[tab_index][query.idx].valid;
    dirty_nxt = dcache[tab_index][query.idx].dirty;

    //set block offset
    offset = query.blkoff;

    //counter variables for flush state
    nxt_count = count;

    //hitCount variables
    missCount_nxt = missCount;
    hitCount_nxt = hitCount;

		case(state)
			IDLE:
				begin
					//hit in table1 for read
					if(isHit1 && dcif.dmemREN)
						begin
							tab_index = 0;
							dcif.dmemload = dcache[0][query.idx].data[query.blkoff]; // send value to datapath
							dcif.dhit = 1;

							lru_nxt = 1; //Table 2 is now the least recently used
							hitCount_nxt = hitCount + 1;
							dirty_nxt = dcache[0][query.idx].dirty;
							valid_nxt = dcache[0][query.idx].valid;
							data_nxt = dcache[0][query.idx].data[query.blkoff];

							nxt_state = IDLE;
						end

					//hit in table2 for read
					else if(isHit2 && dcif.dmemREN)
						begin
							tab_index = 1;
							dcif.dmemload = dcache[1][query.idx].data[query.blkoff]; // send value to datapath
							dcif.dhit = 1;

							lru_nxt = 0; //Table 1 is now the least recently used
							hitCount_nxt = hitCount + 1;
							dirty_nxt = dcache[1][query.idx].dirty;
							valid_nxt = dcache[1][query.idx].valid;
							data_nxt = dcache[1][query.idx].data[query.blkoff];

							nxt_state = IDLE;
						end

					//hit in table1 for write
					else if(isHit1 && dcif.dmemWEN)
						begin
							tab_index = 0;
							dcif.dhit = 1;

							lru_nxt = 1; //Table 2 is now the least recently used
							hitCount_nxt = hitCount + 1;
							dirty_nxt = 1;
							valid_nxt = dcache[1][query.idx].valid;
							data_nxt = dcif.dmemstore;;

							nxt_state = IDLE;
						end

					//hit in table2 for write
					else if(isHit2 && dcif.dmemWEN)
						begin
							tab_index = 0;
							dcif.dhit = 1;

							lru_nxt = 1; //Table 2 is now the least recently used
							hitCount_nxt = hitCount + 1;
							dirty_nxt = 1;
							valid_nxt = dcache[1][query.idx].valid;
							data_nxt = dcif.dmemstore;;

							nxt_state = IDLE;
						end

					//Miss case --> assign next state based on dirty bit of the least recently used table
					else if(dcache[tab_index][query.idx].dirty == 1)		//Write to memory before reading
						begin
							nxt_state = WRITE0;
							missCount_nxt = missCount+1;
						end

					else
						begin
							nxt_state = LOAD0;
							missCount_nxt = missCount+1;
						end

					//Check for Halt --> If enabled, ignore everything
					if(dcif.halt)
						begin
							nxt_state = FLUSH;
						end

				end

			LOAD0:	//Read first word from memory
				begin
					cif.dREN = 1;
					cif.daddr = {dcif.dmemaddr[31:3], 3'b000};
					if(cif.dwait == 1)
						begin
							nxt_state = LOAD0;
						end
					else
						begin
							data_nxt = cif.dload;
							offset = 0;
							nxt_state = LOAD1; //Load second word 
						end	
				end

			LOAD1:	//Read second word from memory
				begin
					cif.dREN = 1;
					cif.daddr = {dcif.dmemaddr[31:3], 3'b100};
					if(cif.dwait == 1)
						begin
							nxt_state = LOAD1;
						end
					else
						begin
							data_nxt = cif.dload; 
							valid_nxt = 1;
							dirty_nxt = 0;
							lru_nxt = ~lru[query.idx];
							offset = 1;
							nxt_state = IDLE; //Load second word
						end
				end

			WRITE0:	//Write first word to memory in case block's dirty bit was set
				begin
					cif.dWEN = 1;
					cif.daddr = {dcache[tab_index][query.idx].tag, query.idx, 3'b000};
					cif.dstore = dcache[tab_index][query.idx].data[0];
					if(cif.dwait == 1)
						begin
							nxt_state = WRITE0;
						end
					else
						begin
							nxt_state = WRITE1;	//Write second word to memory
						end
				end

			WRITE1:
				begin
					cif.dWEN = 1;
					cif.daddr = {dcache[tab_index][query.idx].tag, query.idx, 3'b100};
					cif.dstore = dcache[tab_index][query.idx].data[1];
					if(cif.dwait == 1)
						begin
							nxt_state = WRITE1;
						end
					else
						begin
							nxt_state = LOAD0;	//Write second word to memory
						end
				end

			FLUSH0:	//Flush table1 of the dcache
				begin
					if(count == 8)	//done flushing the whole cache
						begin
							nxt_state = FLUSH1;
							nxt_count = 0';
						end
					else if(dcache[0][count].dirty)	//Write back this data to memory
						begin
							nxt_count = count;
							nxt_state = WB0;
						end
					else
						begin
							nxt_count = count + 1;
							nxt_state = state;
						end
				end	

			WB0_FLUSH0:
				begin
					cif.dWEN = 1;
					cif.daddr = {dcache[0][count].tag, query.idx, 3'b000};
					cif.dstore = dcache[0][query.idx].data[0];
					if(cif.dwait == 1)
						begin
							nxt_state = WB0_FLUSH0;
						end
					else
						begin
							nxt_state = WB1_FLUSH0;	//Write second word to memory
						end
				end

		  WB1_FLUSH0:
		  	begin
					cif.dWEN = 1;
					cif.daddr = {dcache[0][count].tag, query.idx, 3'b100};
					cif.dstore = dcache[0][query.idx].data[1];
					if(cif.dwait == 1)
						begin
							nxt_state = WB1_FLUSH0;
						end
					else
						begin
							nxt_state = FLUSH0;	//Write second word to memory
							nxt_count = count + 1;
						end
				end

			FLUSH1:
				begin
					if(count == 8)	//done flushing the whole cache
						begin
							nxt_state = HALT;
							nxt_count = 0';
						end
					else if(dcache[1][count].dirty)	//Write back this data to memory
						begin
							nxt_count = count;
							nxt_state = WB0_FLUSH1;
						end
					else
						begin
							nxt_count = count + 1;
							nxt_state = state;
						end
				end
			
			WB0_FLUSH1:
				begin
					cif.dWEN = 1;
					cif.daddr = {dcache[1][count].tag, query.idx, 3'b000};
					cif.dstore = dcache[1][query.idx].data[0];
					if(cif.dwait == 1)
						begin
							nxt_state = WB0_FLUSH1;
						end
					else
						begin
							nxt_state = WB1_FLUSH1;	//Write second word to memory
						end
				end

		  WB1_FLUSH1:
		  	begin
					cif.dWEN = 1;
					cif.daddr = {dcache[1][count].tag, query.idx, 3'b100};
					cif.dstore = dcache[1][query.idx].data[1];
					if(cif.dwait == 1)
						begin
							nxt_state = WB1_FLUSH1;
						end
					else
						begin
							nxt_state = FLUSH1;	
							nxt_count = count + 1;
						end
				end

			HALT:
				begin
					cif.dWEN = 1;
					cif.daddr = 0x3100;
					cif.dstore = hitCount-missCount;
					if(cif.dwait == 1)
						begin
							nxt_state = HALT;
						end
					else
						begin
							nxt_state = HALT;
							dcif.flushed = 1;	
						end
				end	

			default : /* default */;
		endcase
	end	