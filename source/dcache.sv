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
  logic lru_nxt;
  logic valid_nxt0, valid_nxt1;
  logic dirty_nxt0, dirty_nxt1;
  logic[25:0] query_tag_nxt0, query_tag_nxt1;
  word_t[1:0] data_nxt0, data_nxt1;

  //counter variable used in the flush state
  logic[3:0] count, nxt_count;

  //hitCount
  word_t hitCount, hitCount_nxt, missCount, missCount_nxt;

//dcache
cache_entry [1:0][7:0] dcache; //8 sets and 2 blocks per set
logic[7:0] lru;

typedef enum {IDLE, LOADTOCACHE0, LOADTOCACHE1, WRITETOMEM_INREAD0, WRITETOMEM_INREAD1, WRITETOMEM_INWRITE0, WRITETOMEM_INWRITE1, WRITETOCACHE, WB0_FLUSH0, WB1_FLUSH0, WB0_FLUSH1, WB1_FLUSH1, FLUSH0, FLUSH1, HALT} state_type;	


state_type state, nxt_state;

//query initializations
assign query.tag = dcif.dmemaddr[31:6];
assign query.idx = dcif.dmemaddr[5:3];
assign query.blkoff = dcif.dmemaddr[2];
assign query.bytoff = 2'b00;


//Hit initializations
assign isHit1 = (dcache[0][query.idx].tag == query.tag && dcache[0][query.idx].valid == 1) ? 1 : 0;
assign isHit2 = (dcache[1][query.idx].tag == query.tag && dcache[1][query.idx].valid == 1) ? 1 : 0;

always_ff @(posedge CLK, negedge nRST)
	begin
    if(nRST == 1'b0) 
      state <= IDLE;
    else
      state <= nxt_state;
 end
 

integer i, x;
always_ff @(posedge CLK, negedge nRST)
	begin
    if(nRST == 1'b0)
    	begin
    		count <= 0;
    		hitCount <= 0;
    		missCount <= 0;
    		
	      for(i = 0; i < 2; i++) 
	      	begin
	        	for (x = 0; x < 8; x++)
	        		begin
		          	dcache[i][x].tag <= '0;
			          dcache[i][x].data[0] <= '0;
			          dcache[i][x].data[1] <= '0;
			          dcache[i][x].valid <= 0;
			          dcache[i][x].dirty <= 0;
      	  		end
      		end

      	for(i = 0; i < 8; i++)
      		begin
      			lru[i] = 0;
      		end
    	end
    else
    	begin
      	lru[query.idx] <= lru_nxt;

      	//Table 0 assignments
      	dcache[0][query.idx].data[0] <= data_nxt0[0];
      	dcache[0][query.idx].data[1] <= data_nxt0[1];
      	dcache[0][query.idx].valid <= valid_nxt0;
      	dcache[0][query.idx].dirty <= dirty_nxt0;
				dcache[0][query.idx].tag <= query_tag_nxt0;

      	//Table1 assignments
      	dcache[1][query.idx].data[0] <= data_nxt1[0];
      	dcache[1][query.idx].data[1] <= data_nxt1[1];
      	dcache[1][query.idx].valid <= valid_nxt1;
      	dcache[1][query.idx].dirty <= dirty_nxt1;
      	dcache[1][query.idx].tag <= query_tag_nxt1;

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

    // lru_nxt init value
    lru_nxt = lru[query.idx];

    // dcache update values
    // Table0
    data_nxt0[0] = dcache[0][query.idx].data[0];
    data_nxt0[1] = dcache[0][query.idx].data[1];	
    valid_nxt0 = dcache[0][query.idx].valid;
    dirty_nxt0 = dcache[0][query.idx].dirty;
    query_tag_nxt0 = dcache[0][query.idx].tag;	
    
    // Table1
    data_nxt1[0] = dcache[1][query.idx].data[0];
    data_nxt1[1] = dcache[1][query.idx].data[1];	
    valid_nxt1 = dcache[1][query.idx].valid;
    dirty_nxt1 = dcache[1][query.idx].dirty;
    query_tag_nxt1 = dcache[1][query.idx].tag;

    //counter variables for flush state
    nxt_count = count;

    //hitCount variables
    missCount_nxt = missCount;
    hitCount_nxt = hitCount;

		case(state)
			IDLE:
				begin
					if(dcif.dmemREN) //data read
						begin
							//hit in table1 for read
							if(isHit1)
								begin
									dcif.dmemload = dcache[0][query.idx].data[query.blkoff]; // send value to datapath
									dcif.dhit = 1;
									lru_nxt = 1; //Table 2 is now the least recently used
									hitCount_nxt = hitCount + 1;
									nxt_state = IDLE;
								end

							//hit in table2 for read
							else if(isHit2)
								begin
									dcif.dmemload = dcache[1][query.idx].data[query.blkoff]; // send value to datapath
									dcif.dhit = 1;
									lru_nxt = 0; //Table 1 is now the least recently used
									nxt_state = IDLE;
									hitCount_nxt = hitCount + 1;
								end

							
							//Miss case --> assign next state based on dirty bit of the least recently used table
							else if(dcache[lru[query.idx]][query.idx].dirty == 1)		//Write to memory before reading
								begin
									nxt_state = WRITETOMEM_INREAD0;
									missCount_nxt = missCount+1;
								end

							else
								begin
									nxt_state = LOADTOCACHE0;
									missCount_nxt = missCount+1;
								end
						end

					else if(dcif.dmemWEN) //data write
						begin
							//hit in table1 for write
							if(isHit1)
								begin
									dcif.dhit = 1;
									lru_nxt = 1; //Table 2 is now the least recently used
									hitCount_nxt = hitCount + 1;
									data_nxt0[query.blkoff] = dcif.dmemstore;;
									nxt_state = IDLE;
								end

							//hit in table2 for write
							else if(isHit2)
								begin
									dcif.dhit = 1;
									lru_nxt = 1; //Table 2 is now the least recently used
									hitCount_nxt = hitCount + 1;
									data_nxt1[query.blkoff] = dcif.dmemstore;;
									nxt_state = IDLE;
								end

							//Miss case --> assign next state based on dirty bit of the least recently used table
							else if(dcache[lru[query.idx]][query.idx].dirty == 1)		//Write to memory before writing to cache
								begin
									nxt_state = WRITETOMEM_INWRITE0;
									missCount_nxt = missCount+1;
								end

							else	//simply change the data in cache
								begin
									nxt_state = WRITETOCACHE;	//This state will change the tag of the block at query.idx, so that we get a hit
									missCount_nxt = missCount+1;
								end
						end

					else if(dcif.halt)
						begin
							nxt_state = FLUSH0;
						end

					else
						begin
							nxt_state = IDLE;
						end
				end

			LOADTOCACHE0:	//Read first word from memory
				begin
					cif.dREN = 1;
					cif.daddr = {dcif.dmemaddr[31:3], 3'b000};
					if(cif.dwait == 1)
						begin
							nxt_state = LOADTOCACHE0;
						end
					else
						begin
							if(lru[query.idx])
								begin
									data_nxt1[0] = cif.dload;			
								end
							else
								begin
									data_nxt0[0] = cif.dload;	
								end
							nxt_state = LOADTOCACHE1; //Load second word 
						end	
				end

			LOADTOCACHE1:	//Read second word from memory
				begin
					cif.dREN = 1;
					cif.daddr = {dcif.dmemaddr[31:3], 3'b100};
					if(cif.dwait == 1)
						begin
							nxt_state = LOADTOCACHE1;
						end
					else
						begin
							if(lru[query.idx])
								begin
									query_tag_nxt1 = query.tag;
									data_nxt1[1] = cif.dload;
									valid_nxt1 = 1;
									dirty_nxt1 = 0;			
								end
							else
								begin
									query_tag_nxt0 = query.tag;
									data_nxt0[1] = cif.dload;	
									valid_nxt0 = 1;
									dirty_nxt0 = 0;
								end
							nxt_state = IDLE; //Load second word
						end
				end

			WRITETOMEM_INREAD0:	//Write first word to memory in case block's dirty bit was set
				begin
					cif.dWEN = 1;
					cif.daddr = {dcache[lru[query.idx]][query.idx].tag, query.idx, 3'b000};
					cif.dstore = dcache[lru[query.idx]][query.idx].data[0];
					if(cif.dwait == 1)
						begin
							nxt_state = WRITETOMEM_INREAD0;
						end
					else
						begin
							nxt_state = WRITETOMEM_INREAD1;	//Write second word to memory
						end
				end

			WRITETOMEM_INREAD1:
				begin
					cif.dWEN = 1;
					cif.daddr = {dcache[lru[query.idx]][query.idx].tag, query.idx, 3'b100};
					cif.dstore = dcache[lru[query.idx]][query.idx].data[1];
					if(cif.dwait == 1)
						begin
							nxt_state = WRITETOMEM_INREAD1;
						end
					else
						begin
							nxt_state = LOADTOCACHE0;	//Write second word to memory
						end
				end

			WRITETOMEM_INWRITE0:
				begin
					cif.dWEN = 1;
					cif.daddr = {dcache[lru[query.idx]][query.idx].tag, query.idx, 3'b000};
					cif.dstore = dcache[lru[query.idx]][query.idx].data[0];
					if(cif.dwait == 1)
						begin
							nxt_state = WRITETOMEM_INWRITE0;
						end
					else
						begin
							nxt_state = WRITETOMEM_INWRITE1;	//Write second word to memory
						end
				end


			WRITETOMEM_INWRITE1:
				begin
					cif.dWEN = 1;
					cif.daddr = {dcache[lru[query.idx]][query.idx].tag, query.idx, 3'b100};
					cif.dstore = dcache[lru[query.idx]][query.idx].data[1];
					if(cif.dwait == 1)
						begin
							nxt_state = WRITETOMEM_INWRITE1;
						end
					else
						begin
							nxt_state = WRITETOCACHE;	//Write second word to memory
						end
				end	
			

			WRITETOCACHE:
				begin
					if(lru[query.idx])
						begin
							query_tag_nxt1 = query.tag;
							valid_nxt1 = 1;
						end
					else
						begin
							query_tag_nxt0 = query.tag;
							valid_nxt0 = 1;
						end
					nxt_state = IDLE;
				end


			FLUSH0:	//Flush table1 of the dcache
				begin
					if(count == 8)	//done flushing the whole cache
						begin
							nxt_state = FLUSH1;
							nxt_count = '0;
						end
					else if(dcache[0][count].dirty)	//Write back this data to memory
						begin
							nxt_count = count;
							nxt_state = WB0_FLUSH0;
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
							nxt_count = '0;
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
					cif.daddr = 32'h00003100;
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
	endmodule // dcache
