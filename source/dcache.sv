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

logic [31:0] link_reg, link_reg_nxt;

//Values used to update cache in always_ff block
logic lru_nxt, valid_nxt0, valid_nxt1, dirty_nxt0, dirty_nxt1, snoop_valid_nxt0, snoop_valid_nxt1, snoop_dirty_nxt0, snoop_dirty_nxt1, isBeingSnooped;
logic[25:0] query_tag_nxt0, query_tag_nxt1;
word_t[1:0] data_nxt0, data_nxt1;
logic cctrans_nxt, ccwrite_nxt, read, read_nxt;

//dcache
cache_entry [1:0][7:0] dcache; //8 sets and 2 blocks per set
logic[7:0] lru;
dcachef_t query, snoop;

// Other signals
logic[3:0] count, nxt_count;//counter variable used in the flush state
logic isHitRead0, isHitRead1, isHitWrite0, isHitWrite1, isSnoopHit0, isSnoopHit1;
typedef enum {IDLE, LOADTOCACHE0, LOADTOCACHE1, WRITETOMEM0, WRITETOMEM1, WB0_FLUSH0, WB1_FLUSH0, WB0_FLUSH1, WB1_FLUSH1, FLUSH0, FLUSH1, END, SNOOP, SNOOP1, SNOOP2} state_type;	
state_type state, nxt_state;


//query initializations
assign query.tag = dcif.dmemaddr[31:6];
assign query.idx = dcif.dmemaddr[5:3];
assign query.blkoff = dcif.dmemaddr[2];
assign query.bytoff = 2'b00;
//Hit initializations
assign isHitRead0 = (dcache[0][query.idx].tag == query.tag && dcache[0][query.idx].valid == 1) ? 1 : 0;
assign isHitRead1 = (dcache[1][query.idx].tag == query.tag && dcache[1][query.idx].valid == 1) ? 1 : 0;
assign isHitWrite0 = (dcache[0][query.idx].tag == query.tag && dcache[0][query.idx].valid == 1 && dcache[0][query.idx].dirty != 0) ? 1 : 0;
assign isHitWrite1 = (dcache[1][query.idx].tag == query.tag && dcache[1][query.idx].valid == 1 && dcache[1][query.idx].dirty != 0) ? 1 : 0;


//snooping initializations
assign snoop.tag = cif.ccsnoopaddr[31:6];
assign snoop.idx = cif.ccsnoopaddr[5:3];
assign snoop.blkoff = cif.ccsnoopaddr[2];
assign snoop.bytoff = 2'b00;
//Snoop hit initializations
assign isSnoopHit0 = dcache[0][snoop.idx].tag == snoop.tag && dcache[0][snoop.idx].valid == 1;
assign isSnoopHit1 = dcache[1][snoop.idx].tag == snoop.tag && dcache[1][snoop.idx].valid == 1;

integer i, x;
always_ff @(posedge CLK, negedge nRST) begin
	if(nRST == 1'b0) begin
		state <= IDLE;
		link_reg <= '0;
		cif.cctrans <= 1'b0;
		cif.ccwrite <= 1'b0;
		read <= 1'b0;
		count <= 0;
	  	for(i = 0; i < 2; i++) begin
    		for (x = 0; x < 8; x++) begin
				dcache[i][x].tag <= '0;
				dcache[i][x].data[0] <= '0;
				dcache[i][x].data[1] <= '0;
				dcache[i][x].valid <= 0;
				dcache[i][x].dirty <= 0;
		  	end
		end
		for(i = 0; i < 8; i++) begin
				lru[i] = 0;
		end
	end 
	else begin
    lru[query.idx] <= lru_nxt;
    link_reg <= link_reg_nxt;
  	//Table 0 assignments
  	dcache[0][query.idx].data[0] <= data_nxt0[0];
  	dcache[0][query.idx].data[1] <= data_nxt0[1];
  	
  	dcache[0][query.idx].dirty <= dirty_nxt0;
		dcache[0][query.idx].tag <= query_tag_nxt0;
		dcache[0][query.idx].valid <= valid_nxt0;
		if (isBeingSnooped)
			dcache[0][snoop.idx].valid <= snoop_valid_nxt0;
	  	dcache[0][snoop.idx].dirty <= snoop_dirty_nxt0;

  	//Table1 assignments
  	dcache[1][query.idx].data[0] <= data_nxt1[0];
  	dcache[1][query.idx].data[1] <= data_nxt1[1];
  	
  	dcache[1][query.idx].dirty <= dirty_nxt1;
  	dcache[1][query.idx].tag <= query_tag_nxt1;
		dcache[1][query.idx].valid <= valid_nxt1;
  	if (isBeingSnooped)
			dcache[1][snoop.idx].valid <= snoop_valid_nxt1;
	  	dcache[1][snoop.idx].dirty <= snoop_dirty_nxt1;

  	state <= nxt_state;
  	read <= read_nxt;
		cif.cctrans <= cctrans_nxt;
		cif.ccwrite <= ccwrite_nxt;
		count <= nxt_count;
    end
 end


//State machine
always_comb begin
	nxt_state = state;
   isBeingSnooped = 0; 
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
    snoop_valid_nxt0 = dcache[0][snoop.idx].valid;
    snoop_dirty_nxt0 = dcache[0][snoop.idx].dirty;

    // Table1
    data_nxt1[0] = dcache[1][query.idx].data[0];
    data_nxt1[1] = dcache[1][query.idx].data[1];	
    valid_nxt1 = dcache[1][query.idx].valid;
    dirty_nxt1 = dcache[1][query.idx].dirty;
    query_tag_nxt1 = dcache[1][query.idx].tag;
    snoop_valid_nxt1 = dcache[1][snoop.idx].valid;
    snoop_dirty_nxt1 = dcache[1][snoop.idx].dirty;

    //counter variables for flush state
    nxt_count = count;

    cctrans_nxt = cif.cctrans;
    ccwrite_nxt = cif.ccwrite;
    read_nxt = read;
    link_reg_nxt = link_reg;

		case(state)
			IDLE:
				begin
					//cctrans_nxt = 0;
					//ccwrite_nxt = 0;
					if (cif.ccwait) begin
						nxt_state = SNOOP;
					end

					else if(dcif.dmemREN) begin //data read
						if (dcif.datomic) 
							link_reg_nxt <= dcif.dmemaddr;

						if(isHitRead0) begin // hit in cache 0 for read
							dcif.dmemload = dcache[0][query.idx].data[query.blkoff]; // send value to datapath
							dcif.dhit = 1;
							lru_nxt = 1; // Cache 1 is now the least recently used
							nxt_state = IDLE;
							cctrans_nxt = 1'b0;
							ccwrite_nxt = 1'b0;
						end

						else if (isHitRead1) begin // hit in cache 1 for read
							dcif.dmemload = dcache[1][query.idx].data[query.blkoff]; // send value to datapath
							dcif.dhit = 1;
							lru_nxt = 0; //Cache 0 is now the least recently used
							nxt_state = IDLE;
							cctrans_nxt = 1'b0;
							ccwrite_nxt = 1'b0;
						end
						
						else if(dcache[lru[query.idx]][query.idx].dirty == 1 && dcache[lru[query.idx]][query.idx].valid == 1) begin	// If lru cache is dirty must write before using it
							ccwrite_nxt = 1'b1;
							cctrans_nxt = 1'b0;
							read_nxt = 1'b1;
							nxt_state = WRITETOMEM0; // write dirty value to memory before reading
						end

						else begin
							if (dcache[lru[query.idx]][query.idx].valid != 1) // if lru cache is not valid will be transitioning states
								cctrans_nxt = 1'b1;
							else
								cctrans_nxt = 1'b0;

							ccwrite_nxt = 1'b0;
							nxt_state = LOADTOCACHE0;
						end
					end

					else if(dcif.dmemWEN) begin //data write
						if (dcif.dmemaddr == link_reg && ~dcif.datomic) // if address matches and not sc 
								link_reg_nxt <= '0; // invalidate

						if (dcif.datomic && (dcif.dmemaddr != link_reg)) // if atomic and addresses don't match
							dcif.dmemload = 0;
						else if (dcif.datomic && (dcif.dmemaddr == link_reg)) // if atomic and addresses match
							dcif.dmemload = 1;
							link_reg_nxt <= '0; // now invalidate

						if(isHitWrite0) begin // hit in cache 0 for write
							dcif.dhit = 1;
							// if(query.blkoff)
							// 	cif.daddr = {dcif.dmemaddr[31:3], 3'b100};
							// else
							// 	cif.daddr = {dcif.dmemaddr[31:3], 3'b000};

							lru_nxt = 1; // Cache 1 now least recently sed
							data_nxt0[query.blkoff] = dcif.dmemstore;
							dirty_nxt0 = 1;
							valid_nxt0 = 1;
							if (~dcache[0][query.idx].dirty) begin // if in shared state move to modified
								ccwrite_nxt = 1'b1;
								cctrans_nxt = 1'b1;
							end
							else begin
								ccwrite_nxt = 1'b0;
								cctrans_nxt = 1'b0;
							end
							nxt_state = IDLE;
						end

						else if(isHitWrite1) begin // hit in cache 1 for write
							dcif.dhit = 1;
							// if(query.blkoff)
							// 	cif.daddr = {dcif.dmemaddr[31:3], 3'b100};
							// else
							// 	cif.daddr = {dcif.dmemaddr[31:3], 3'b000};

							lru_nxt = 0; // Cache 0 is now the least recently used
							data_nxt1[query.blkoff] = dcif.dmemstore;
							dirty_nxt1 = 1;
							valid_nxt1 = 1;
							if (~dcache[1][query.idx].dirty) begin // if in shared state move to modified
								ccwrite_nxt = 1'b1;
								cctrans_nxt = 1'b1;
							end
							else begin
								ccwrite_nxt = 1'b0;
								cctrans_nxt = 1'b0;
							end
							nxt_state = IDLE;
						end

						else if(dcache[lru[query.idx]][query.idx].dirty == 1 && dcache[lru[query.idx]][query.idx].valid == 1) begin	// Cache miss. If lru cache is dirty must write before using it
							read_nxt = 1'b0;
							cctrans_nxt = 1'b0;
							ccwrite_nxt = 1'b0;
							nxt_state = WRITETOMEM0; // write dirty value to memory before writing
						end

						else begin // Simply change the data in cache
							cctrans_nxt = 1'b1;
							ccwrite_nxt = 1'b1;
							nxt_state = LOADTOCACHE0;	
						end
					end
					else if(dcif.halt) begin
							nxt_state = FLUSH0;
					end

					else begin
							nxt_state = IDLE;
							cctrans_nxt = 1'b0;
							ccwrite_nxt = 1'b0;
					end
				end

			LOADTOCACHE0:	//Read first word from memory
				begin
					cif.dREN = 1;
					cif.daddr = {dcif.dmemaddr[31:3], 3'b000};
					if(cif.dwait == 1) begin
						nxt_state = LOADTOCACHE0;
					end
					else begin
						if(lru[query.idx]) begin
							data_nxt1[0] = cif.dload;			
						end
						else begin
							data_nxt0[0] = cif.dload;	
						end
						nxt_state = LOADTOCACHE1; //Load second word 
					end	
				end

			LOADTOCACHE1:	//Read second word from memory
				begin
					cif.dREN = 1;
					cif.daddr = {dcif.dmemaddr[31:3], 3'b100};
					if(cif.dwait == 1) begin
						nxt_state = LOADTOCACHE1;
					end
					else begin
						if(lru[query.idx]) begin
							query_tag_nxt1 = query.tag;
							data_nxt1[1] = cif.dload;
							valid_nxt1 = 1;
							if(dcif.dmemREN)
								dirty_nxt1 = 0;
							else if(dcif.dmemWEN)
								dirty_nxt1 = 1;		
								if(dcache[0][query.idx].tag == query.tag)
									valid_nxt0 = 0;
						end
						else begin
							query_tag_nxt0 = query.tag;
							data_nxt0[1] = cif.dload;	
							valid_nxt0 = 1;
							if(dcif.dmemREN)
								dirty_nxt0 = 0;
							else if(dcif.dmemWEN)
								dirty_nxt0 = 1;	
								if(dcache[1][query.idx].tag == query.tag)
									valid_nxt1= 0;
						end
						nxt_state = IDLE; 
						cctrans_nxt = 0;
						ccwrite_nxt = 0;
					end
				end


			WRITETOMEM0:	//Write first word to memory in case block's dirty bit was set
				begin
					cif.dWEN = 1;
					cif.daddr = {dcache[lru[query.idx]][query.idx].tag, query.idx, 3'b000};
					cif.dstore = dcache[lru[query.idx]][query.idx].data[0];
					if(cif.dwait == 1) begin
						nxt_state = WRITETOMEM0;
					end
					else begin
						nxt_state = WRITETOMEM1;	//Write second word to memory
					end
				end

			WRITETOMEM1:
				begin
					cif.dWEN = 1;
					cif.daddr = {dcache[lru[query.idx]][query.idx].tag, query.idx, 3'b100};
					cif.dstore = dcache[lru[query.idx]][query.idx].data[1];
					if(cif.dwait == 1) begin
						nxt_state = WRITETOMEM1;
					end
					else begin
						if (read) begin
							cctrans_nxt = 0;
							ccwrite_nxt = 0;
							nxt_state = LOADTOCACHE0;	
						end
						else begin
							nxt_state = LOADTOCACHE0;
						end
					end
				end


			FLUSH0:	//Flush table1 of the dcache
				begin
					if(count == 8) begin	//done flushing the whole cache
						nxt_state = FLUSH1;
						nxt_count = '0;
					end
					else if(dcache[0][count[2:0]].dirty && dcache[0][count[2:0]].valid) begin	//Write back this data to memory
							nxt_count = count;
							nxt_state = WB0_FLUSH0;
							valid_nxt0 = 0;
							dirty_nxt0 = 0;
					end
					else begin
							nxt_count = count + 1;
							nxt_state = FLUSH0;
							valid_nxt0 = 0;
							dirty_nxt0 = 0;							
					end
				end	

			WB0_FLUSH0:
				begin
					cif.dWEN = 1;
					cif.daddr = {dcache[0][count[2:0]].tag, count[2:0], 3'b000};
					cif.dstore = dcache[0][count[2:0]].data[0];
					if(cif.dwait == 1) begin
						nxt_state = WB0_FLUSH0;
					end
					else begin
						nxt_state = WB1_FLUSH0;	//Write second word to memory
					end
				end

		  WB1_FLUSH0:
		  	begin
					cif.dWEN = 1;
					cif.daddr = {dcache[0][count[2:0]].tag, count[2:0], 3'b100};
					cif.dstore = dcache[0][count[2:0]].data[1];
					if(cif.dwait == 1) begin
						nxt_state = WB1_FLUSH0;
					end
					else begin
						nxt_state = FLUSH0;	//Write second word to memory
						nxt_count = count + 1;
					end
				end

			FLUSH1:
				begin
					if(count == 8) begin	//done flushing the whole cache
						nxt_state = END;
						nxt_count = '0;
					end
					else if(dcache[1][count[2:0]].dirty && dcache[1][count[2:0]].valid) begin	//Write back this data to memory
							nxt_count = count;
							nxt_state = WB0_FLUSH1;
							valid_nxt0 = 0;
							dirty_nxt0 = 0;							
					end
					else begin
							nxt_count = count + 1;
							nxt_state = FLUSH1;
							valid_nxt0 = 0;
							dirty_nxt0 = 0;							
					end
				end
			
			WB0_FLUSH1:
				begin
					cif.dWEN = 1;
					cif.daddr = {dcache[1][count[2:0]].tag, count[2:0], 3'b000};
					cif.dstore = dcache[1][count[2:0]].data[0];
					if(cif.dwait == 1) begin
						nxt_state = WB0_FLUSH1;
					end
					else begin
						nxt_state = WB1_FLUSH1;	//Write second word to memory
					end
				end

		  WB1_FLUSH1:
		  	begin
					cif.dWEN = 1;
					cif.daddr = {dcache[1][count[2:0]].tag, count[2:0], 3'b100};
					cif.dstore = dcache[1][count[2:0]].data[1];
					if(cif.dwait == 1) begin
						nxt_state = WB1_FLUSH1;
					end
					else begin
						nxt_state = FLUSH1;	
						nxt_count = count + 1;
					end
				end


			SNOOP:
				begin
					isBeingSnooped = 1;
					// If dchache[0/1][snoopTag] == snoopaddrTag and Valid then snoop hit
					if (isSnoopHit0 || isSnoopHit1) begin
						if (~cif.ccwait) begin // will be going back to IDLE
							ccwrite_nxt = 1'b0;
							cctrans_nxt = 1'b0;
							nxt_state = IDLE;
						end
						else begin
							ccwrite_nxt = 1'b1;
							cctrans_nxt = 1'b1;
							if (cif.ccsnoopaddr == link_reg) // if snoop address matches and a write
								link_reg_nxt <= '0; // invalidate

							nxt_state = SNOOP1;
						end
					end
					else begin
						if (~cif.ccwait) begin // will be going back to IDLE
							ccwrite_nxt = 1'b0;
							cctrans_nxt = 1'b0;
							nxt_state = IDLE;
						end
						else begin
							ccwrite_nxt = 1'b0;
							cctrans_nxt = 1'b1;
							nxt_state = SNOOP;
						end
					end

					if (cif.ccinv)
					begin// invalidate cache entry for snoop address 
						if(isSnoopHit0 && ~dcache[0][snoop.idx].dirty)
							begin
								snoop_valid_nxt0 = 1'b0;
							end
						else if(isSnoopHit0)
							begin
								snoop_dirty_nxt0 = 1'b0;
							end

						if(isSnoopHit1 && ~dcache[1][snoop.idx].dirty)
							begin
								snoop_valid_nxt1 = 1'b0;
							end
						else if(isSnoopHit1)
							begin
								snoop_dirty_nxt1 = 1'b0;
							end
					end
				end

			SNOOP1: // snoophit: pass first ramaddr and value
				begin
					isBeingSnooped = 1;
					cif.daddr = {snoop.tag, snoop.idx, 3'b000};
					
					if (isSnoopHit0) 
						cif.dstore = dcache[0][snoop.idx].data[0];
					else  // snoophit1
						cif.dstore = dcache[1][snoop.idx].data[0];

					if (cif.dwait == 1) 
						nxt_state = SNOOP1;
					else begin
						nxt_state = SNOOP2;
						ccwrite_nxt = 1'b0;
						cctrans_nxt = 1'b0;
					end

				end

			SNOOP2: // snoophit: pass second ramaddr and value
				begin
					isBeingSnooped = 1;
					cif.daddr = {snoop.tag, snoop.idx, 3'b100};
					
					if (isSnoopHit0) 
						cif.dstore = dcache[0][snoop.idx].data[1];
					else  // snoophit1
						cif.dstore = dcache[1][snoop.idx].data[1];

					if (cif.dwait == 1) 
						nxt_state = SNOOP2;
					else
						begin
							nxt_state = IDLE;
							cctrans_nxt = 0;
							ccwrite_nxt = 0;
							if (cif.ccinv) begin// invalidate cache entry for snoop address 
								if(isSnoopHit0)
									begin
										snoop_valid_nxt0 = 1'b0;
									end
								else if(isSnoopHit1)
									begin
										snoop_valid_nxt1 = 1'b0;
									end
							end							
						end
				end

			END:
				begin
					dcif.flushed = 1;
					if (cif.ccwait)
						cctrans_nxt = 1'b1;
					else 
						cctrans_nxt = 1'b0;
					
					ccwrite_nxt = 1'b0;	
					nxt_state = END;
				end

			default : /* default */;
		endcase
	end
	endmodule // dcache
