////////////////////////////////////////////////////////////////////////////////////
///                       Cocotb Verification Project                           ////
///                           Clock Generator                                   ////
////////////////////////////////////////////////////////////////////////////////////
///   Top Module                                                                ////
///   Copyright 2025 Ujval Madhu, All rights reserved                           ////
////////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: clocks_tb.py,v 1.0
//
//  $Date: 2025-26-02
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu

`timescale 1ns/1ps

module top(

    input clk1, clk2, clk3

);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1,top);
end

endmodule