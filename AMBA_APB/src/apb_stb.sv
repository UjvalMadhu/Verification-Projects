////////////////////////////////////////////////////////////////////////////////////
///                        UVM Verification Project                             ////
///                           AMBA APB5 Protocol                                ////
////////////////////////////////////////////////////////////////////////////////////
///   Simple Testbench top module                                               ////
///   Copyright 2025 Ujval Madhu, All rights reserved                           ////
////////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: apb_stb.sv,v 1.0
//
//  $Date: 2025-01-30
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu

module test;
	reg clk;
	reg rst_n;

	parameter int DATA_WIDTH = 32;
	parameter int ADDR_WIDTH = 32;


	// Interface Instantiation
	apb_inf #(DATA_WIDTH,ADDR_WIDTH) inf(
		.pclk(clk),
		.preset_n(rst_n)
		);

	// DUT Intstantiation
	apb_comp top(.inf(inf));

	
	// Clock Generation
	initial begin
		clk 			<= 1'b0;
		forever #5 clk 	<= ~clk;
	end 

	// Reset Generation
	initial begin
		rst_n 		<= 0; 
		repeat(5) @(posedge clk);
		rst_n 		<= 1;
	end

	// Interface Signal Assignment
	assign inf.pclk 	= clk;
	assign inf.preset_n = rst_n;

    
    // Initialize signals
    initial begin
        inf.paddr = '0;
        inf.pprot = '0;
        inf.psel = '0;
        inf.penable = '0;
        inf.pwrite = '0;
        inf.pwdata = '0;
        inf.pstrb = '0;
    end


	// Write Task
	task automatic apbWriteTransaction(input logic [ADDR_WIDTH-1:0] addr, input logic [DATA_WIDTH-1:0] wdata, input logic [2:0] pprot);
		
		// IDLE to SETUP
		@(inf.requester_cb);
		inf.requester_cb.paddr   <= addr;
		inf.requester_cb.pprot   <= pprot;
		inf.requester_cb.pwrite  <= 1'b1;
		inf.requester_cb.psel    <= 1'b1;
		inf.requester_cb.pwdata  <= wdata;
		inf.requester_cb.pstrb   <= {DATA_WIDTH/8{1'b1}};

		// SETUP to ACCESS
		@(inf.requester_cb);		
		inf.requester_cb.penable <= 1'b1;
		
		// Wait for PREADY
		do @(inf.requester_cb);
		while(!inf.requester_cb.pready);

		// ACCESS to IDLE
		@(inf.requester_cb)
		inf.requester_cb.psel    <= 1'b0;
		inf.requester_cb.penable <= 1'b0;
		inf.requester_cb.paddr   <= {ADDR_WIDTH{1'b0}};
		inf.requester_cb.pwdata   <= {DATA_WIDTH{1'b0}};

	endtask : apbWriteTransaction

	// Read Task
	task apbReadTransaction(input logic [ADDR_WIDTH-1:0] addr, output logic [DATA_WIDTH-1:0] rdata, input logic [2:0] pprot);
		
		// IDLE to SETUP
		@(inf.requester_cb);
		inf.requester_cb.paddr   <= addr;
		inf.requester_cb.pprot   <= pprot;
		inf.requester_cb.pwrite  <= 1'b0;
		inf.requester_cb.psel    <= 1'b1;

		// SETUP to ACCESS
		@(inf.requester_cb);		
		inf.requester_cb.penable <= 1'b1;
		
		// Wait for PREADY
		do @(inf.requester_cb);
		while(!inf.requester_cb.prdata);

		// Capture Read Data
		rdata 					<= inf.requester_cb.prdata;
		$display("addr = %0h, read data = %0h", addr, rdata);
		$display("FROM DUT: addr = %0h, read data = %0h", inf.requester_cb.paddr, inf.requester_cb.prdata);

		// ACCESS to IDLE
		@(inf.requester_cb)
		inf.requester_cb.psel    <= 1'b0;
		inf.requester_cb.penable <= 1'b0;
		inf.requester_cb.paddr   <= {ADDR_WIDTH{1'b0}};
	
	endtask : apbReadTransaction

	// Test Stimulus
	initial begin
		logic [DATA_WIDTH-1:0] rdata;

		wait(rst_n);
		repeat(5) @(posedge clk);

		// Write test
		apbWriteTransaction(32'h84, 32'h1234_5678, 3'b010);
		if(inf.requester_cb.pslverr)
			$display("Error: PSLVERR when writing to addr = %0h", 32'h84);

		// Read Test
		apbReadTransaction(32'h84, rdata, 3'b000);
		if(inf.requester_cb.pslverr)
			$display("Error: PSLVERR when reading from addr = %0h", 32'h84);


		// Check data
		if(rdata == 32'h1234_5678)
			$display("Test Passed: Write and Read Transactions Match at addr = %0h", 32'h84);
		else
			$display("Error: Write and Read Transactions do not Match at addr = %0h, read data = %0h", 32'h84, rdata);

		repeat(5) @(posedge clk);
		$finish;

	end

endmodule : test