////////////////////////////////////////////////////////////////////////////////////
///                       Cocotb Verification Project                           ////
///                           Priority Encoder                                  ////
////////////////////////////////////////////////////////////////////////////////////
///   Top Module: Big-endian based priority encoding                            ////
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

    input en,
    input [7:0] din,
    output reg [2:0] out

);

always@(*) begin
    out = 3'd0;
    if(en == 1) begin
        casez(din)
            8'b 1???_????: out = 3'd7;
            8'b 01??_????: out = 3'd6;
            8'b 001?_????: out = 3'd5;
            8'b 0001_????: out = 3'd4;
            8'b 0000_1???: out = 3'd3;
            8'b 0000_01??: out = 3'd2;
            8'b 0000_001?: out = 3'd1;
            8'b 0000_0001: out = 3'd0;
            default:       out = 3'd0;  
        endcase
    end                
end


initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1,top);
end

endmodule