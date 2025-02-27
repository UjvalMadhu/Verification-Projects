////////////////////////////////////////////////////////////////////////////////////
///                       Cocotb Verification Project                           ////
///                             4-Bit Adder                                     ////
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
 
module adder(

    input [3:0] a, b,
    output [4:0] sum

);
 
    assign sum = a+b;

    always @(sum) begin

        $display("Sum is %d", sum);

    end
 
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1,adder);        // all the variables of specified module : adder
        #500;
        $finish;
    end
 
endmodule