///                       Cocotb Verification Project                           ///
///                         4-bit Ripple Carry Adder                            ///
///////////////////////////////////////////////////////////////////////////////////
///   Top Module                                                                ///
///   Copyright 2025 Ujval Madhu, All rights reserved                           ///
///////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: rca4b.sv 1.0
//
//  $Date: 2025-28-02
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu

module top(
    input [3:0] a, b,
    input cin,
    output [3:0] sum,
    output cout
);

// Wire elements
wire c0, c1, c2;

// Instantiating the full adders

full_adder fa0(

    .a(a[0]),
    .b(b[0]),
    .cin(cin),
    .sum(sum[0]),
    .cout(c0)

);

full_adder fa1(

    .a(a[1]),
    .b(b[1]),
    .cin(c0),
    .sum(sum[1]),
    .cout(c1)

);

full_adder fa2(

    .a(a[2]),
    .b(b[2]),
    .cin(c1),
    .sum(sum[2]),
    .cout(c2)

);

full_adder fa3(

    .a(a[3]),
    .b(b[3]),
    .cin(c2),
    .sum(sum[3]),
    .cout(cout)

);

// waveform gen
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1,top);
end

endmodule