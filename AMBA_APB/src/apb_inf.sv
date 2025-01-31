////////////////////////////////////////////////////////////////////////////////////
///                        UVM Verification Project                             ////
///                           AMBA APB5 Protocol                                ////
////////////////////////////////////////////////////////////////////////////////////
///   APB5 Interface                                                            ////
///   Copyright 2025 Ujval Madhu, All rights reserved                           ////
////////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: apb_inf.sv,v 1.0
//
//  $Date: 2025-01-30
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu

interface apb_inf #(parameter int DATA_WIDTH = 32, 
					parameter int ADDR_WIDTH = 32) (pclk, preset_n);
	input logic 						pclk;
	input logic						preset_n;
	logic [ADDR_WIDTH-1:0]  	paddr;
	logic [2:0]     			pprot;
	logic 						psel;
	logic 						penable;
	logic 						pwrite;
	logic [DATA_WIDTH-1:0] 		pwdata;
	logic [(DATA_WIDTH/8)-1:0]  pstrb;
	logic           			pready;
	logic [DATA_WIDTH:0]    	prdata;
	logic           			pslverr;


	// Requester Clocking Block
	clocking requester_cb @(posedge pclk);
		output paddr, psel, penable, pwrite, pwdata, pstrb, pprot;
		input  prdata, pready, pslverr;
	endclocking

	// Monitor Clocking Block
	clocking monitor_cb @(posedge pclk);
		output paddr, psel, penable, pwrite, pwdata, pstrb, pprot;
		input  prdata, pready, pslverr;
	endclocking

	// Completer Clocking Block
	clocking completer_cb @(posedge pclk);
		input   paddr, psel, penable, pwrite, pwdata, pstrb, pprot;
		output  prdata, pready, pslverr;
	endclocking

	// Modport Definitions
	modport req(clocking requester_cb);
	modport mon(clocking monitor_cb);
	modport comp(clocking completer_cb);

endinterface