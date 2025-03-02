///////////////////////////////////////////////////////////////////////////////////
///                       Cocotb Verification Project                           ///
///                                8 Bit RAM                                    ///
///////////////////////////////////////////////////////////////////////////////////
///   Top Module: 16 Memory Locations, Single Port Synchronous Write/Read,      ///
///               Asynchronous Active Low Reset                                 ///
///   Copyright 2025 Ujval Madhu, All rights reserved                           ///
///////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: ram8b.py,v 1.0
//
//  $Date: 2025-01-03
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu
`timescale 1ns/1ps

module top(

    input clk, rst_n,
    input wr_en,
    input [3:0] addr,
    input [7:0] din,
    output reg [7:0] dout

);

// Initializing Memory Block
reg [7:0] mem [0:15];


// Sequential Read Write Logic
always @(posedge clk or negedge rst_n) begin

    if(!rst_n) begin
        for(int i = 0; i < 16; i++)
            mem[i] <= 8'd0;

        dout <= 8'd0;
    
    end

    else if(wr_en == 1'b1)
        mem[addr] <= din;
    
    else dout <= mem[addr];

end

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1,top);
end

endmodule