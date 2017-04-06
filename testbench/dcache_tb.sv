
// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
// import types	
import cpu_types_pkg::*;


// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module dcache_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // clock
  always #(PERIOD/2) CLK++;

  //interface
  datapath_cache_if dcif();
  //two caches to simulate 2 processors
  caches_if cif0(); 
  caches_if cif1();


  //test program
  test PROG(CLK, dcif, cif0, cif1, nRST);

  //DUT
	//`ifndef MAPPED
	dcache DUT0(CLK, nRST, dcif, cif0);
  dcache DUT0(CLK, nRST, dcif, cif1);
  // `else
  // dcache DUT(
  // 	.\cif.iwait(cif.iwait),
  // 	.\cif.dwait(cif.dwait),
  // 	.\cif.iREN(cif.iREN),
  // 	.\cif.dREN(cif.dREN),
  // 	.\cif.dWEN(cif.dWEN),
  // 	.\cif.iload(cif.iload),
  // 	.\cif.dload(cif.dload),
  // 	.\cif.dstore(cif.dstore),
  // 	.\cif.iaddr(cif.iaddr),
  // 	.\cif.daddr(cif.daddr),
  // 	.\cif.ccwait(cif.ccwait),
  // 	.\cif.ccinv(cif.ccinv),
  // 	.\cif.ccwrite(cif.ccwrite),
  // 	.\cif.cctrans(cif.cctrans),
  // 	.\cif.ccnoopaddr(cif.ccsnoopaddr),
  // 	.\dcif.halt(dcif.halt),
  // 	.\dcif.ihit(dcif.ihit),
  // 	.\dcif.imemREN(dcif.imemREN),
  // 	.\dcif.imemload(dcif.imemload),
  // 	.\dcif.imemaddr(dcif.imemaddr),
  // 	.\dcif.dhit(dcif.dhit),
  // 	.\dcif.datomic(dcif.datomic),
  // 	.\dcif.dmemREN(dcif.dmemREN),
  // 	.\dcif.dmemWEN(dcif.dmemWEN),
  // 	.\dcif.flushed(dcif.flushed),
  // 	.\dcif.dmemload(dcif.dmemload),
  // 	.\dcif.dmemstore(dcif.dmemstore),
  // 	.\dcif.dmemaddr(dcif.dmemaddr),
  //   .\nRST (nRST),
  //   .\CLK (CLK)
  //   );
  // `endif
  endmodule // dcache_tb

  program test(
  	input logic CLK,
  	datapath_cache_if.dcache dcif,
  	caches_if.dcache cif0,
    caches_if.dcache cif1,
  	output logic nRST
  );

  import cpu_types_pkg::*;
  parameter PERIOD = 10;

  initial begin
    // Reset everything
    nRST = 0;
    //caches initializations
    cif0.dwait = 1;
    cif0.dload = 32'hBAD1BAD1;
    cif0.ccwait = 0;
    cif0.ccinv = 0;
    cif0.ccsnoopaddr = 32'hB00B1E5; 
    cif1.ccwait = 0;
    cif1.ccinv = 0;
    cif1.ccsnoopaddr = 32'hB00B1E5;
    cif1.dwait = 1;
    cif1.dload = 32'hBAD1BAD1;
    //datapath initializations
    dcif.halt = 0;
    dcif.dmemWEN = 0;
    dcif.dmemaddr = 32'hBAD1BAD1;
    dcif.dmemstore = 32'hBAD1BAD1;
    dcif.dmemREN = 0;
    #(PERIOD);


    /////////////// READS //////////////////

    // Read miss and service cache0 when request from both processors
    nRST = 1;
    dcif.dmemREN = 1;
    dcif.dmemaddr = 32'h10000008;
    #(PERIOD);
    #(PERIOD);
    cif0.dwait = 0; // RAM now has first data value
    cif0.dload = 32'h12345678; // first read data
    #(PERIOD)
    cif0.dwait = 1; // RAM reading second value
    #(PERIOD)
    cif0.dwait = 0; /// RAM now has second data value
    cif0.dload = 32'hfedcba98; // second read data
    #(PERIOD)
    dcif.dmemREN = 0; // done reading
    dcif.dmemaddr = 32'hBAD1BAD1; // done reading
    cif0.dwait = 1; /// RAM now has second data value
    #(PERIOD)
    #(PERIOD)

    // Read miss and service cache1 when no request from first processor 
    dcif.dmemREN = 1;
    dcif.dmemaddr = 32'h11000008;
    cif1.dload = 32'hBAD1BAD1;
    #(PERIOD);
    #(PERIOD);
    cif1.dwait = 0; // RAM now has first data value
    cif1.dload = 32'h10101010; // first read data
    #(PERIOD)
    cif1.dwait = 1; // RAM reading second value
    #(PERIOD)
    cif1.dwait = 0; /// RAM now has second data value
    cif1.dload = 32'h11001100; // second read data
    #(PERIOD)
    dcif.dmemREN = 0; // done reading
    dcif.dmemaddr = 32'hBAD1BAD1; // done reading
    cif1.dwait = 1; /// RAM now has second data value

    #(PERIOD)


    // Read hit and service cache0 when request from both processors
    #(PERIOD);
    dcif.dmemREN = 1;
    dcif.dmemaddr = 32'h10000008; //Read from address that earlier got a miss
    #(PERIOD);
    dcif.dmemREN = 0;


    // Read hit and service cache1 when request from only from processor1
    #(PERIOD);
    dcif.dmemREN = 1;
    dcif.dmemaddr = 32'h11000008; //Read from address that earlier got a miss
    #(PERIOD);
    dcif.dmemREN = 0;

    /////////////// READS END //////////////////


    /////////////// WRITES //////////////////

    // Write hit and service cache0 when request from both processors
    #(PERIOD);
    dcif.dmemWEN = 1;
    dcif.dmemaddr = 32'h10000008;
    dcif.dmemstore = 32'h11110101;
    #(PERIOD);
    dcif.dmemWEN = 0;
    dcif.dmemaddr = 32'hBAD1BAD1;
    dcif.dmemstore = 32'hBAD1BAD1;


    // Write hit and service cache1 when request only from processor1
    #(PERIOD);
    dcif.dmemWEN = 1;
    dcif.dmemaddr = 32'h11000008;
    dcif.dmemstore = 32'h11110101;
    #(PERIOD);
    dcif.dmemWEN = 0;
    dcif.dmemaddr = 32'hBAD1BAD1;
    dcif.dmemstore = 32'hBAD1BAD1;


    // Write miss and service cache0 when request from both processors
    #(PERIOD);
    dcif.dmemWEN = 1;
    dcif.dmemaddr = 32'h11000111;
    dcif.dmemstore = 32'h00011101;
    #(PERIOD);
    #(PERIOD);
    cif0.dwait = 0; // RAM now has first data value
    cif0.dload = 32'h12345678; // first read data
    #(PERIOD)
    cif0.dwait = 1; // RAM reading second value
    #(PERIOD)
    cif0.dwait = 0; /// RAM now has second data value
    cif0.dload = 32'hfedcba98; // second read data
    #(PERIOD)
    cif0.dwait = 1; /// RAM now has second data value

    #(PERIOD); // Done writing
    dcif.dmemWEN = 0;
    dcif.dmemaddr = 32'hBAD1BAD1;
    dcif.dmemstore = 32'hBAD1BAD1;
    #(PERIOD);
    #(PERIOD);


    // Write miss and service cache1 when request from processor 1 only
    #(PERIOD);
    dcif.dmemWEN = 1;
    dcif.dmemaddr = 32'h11000111;
    dcif.dmemstore = 32'h00011101;
    #(PERIOD);
    #(PERIOD);
    cif1.dwait = 0; // RAM now has first data value
    cif1.dload = 32'h12345678; // first read data
    #(PERIOD)
    cif1.dwait = 1; // RAM reading second value
    #(PERIOD)
    cif1.dwait = 0; /// RAM now has second data value
    cif1.dload = 32'hfedcba98; // second read data
    #(PERIOD)
    cif1.dwait = 1; /// RAM now has second data value

    #(PERIOD); // Done writing
    dcif.dmemWEN = 0;
    dcif.dmemaddr = 32'hBAD1BAD1;
    dcif.dmemstore = 32'hBAD1BAD1;
    #(PERIOD);
    #(PERIOD);


    // Read miss with replace
    dcif.dmemREN = 1;
    dcif.dmemaddr = 32'h11100008;
    cif.dload = 32'hBAD1BAD1;
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    cif.dwait = 0; // RAM now has first data value
    cif.dload = 32'h10101010; // first read data
    #(PERIOD)
    cif.dwait = 1; // RAM reading second value
    #(PERIOD)
    cif.dwait = 0; /// RAM now has second data value
    cif.dload = 32'h11001100; // second read data
    #(PERIOD)
    dcif.dmemREN = 0; // done reading
    dcif.dmemaddr = 32'hBAD1BAD1; // done reading
    cif.dwait = 1; /// RAM now has second data value

    #(PERIOD);
    #(PERIOD);

  end


  task automatic reset();
    import cpu_types_pkg::*;
    // Initialization
    nRST = 1;
    //caches initializations
    cif0.dwait = 1;
    cif0.dload = 32'hBAD1BAD1;
    cif0.ccwait = 0;
    cif0.ccinv = 0;
    cif0.ccsnoopaddr = 32'hB00B1E5; 
    cif1.ccwait = 0;
    cif1.ccinv = 0;
    cif1.ccsnoopaddr = 32'hB00B1E5;
    cif1.dwait = 1;
    cif1.dload = 32'hBAD1BAD1;
    //datapath initializations
    dcif.halt = 0;
    dcif.dmemWEN = 0;
    dcif.dmemaddr = 32'hBAD1BAD1;
    dcif.dmemstore = 32'hBAD1BAD1;
    dcif.dmemREN = 0;
  endtask

  endprogram
  