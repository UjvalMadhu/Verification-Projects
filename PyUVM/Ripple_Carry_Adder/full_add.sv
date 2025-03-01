///////////////////////////////////////////////////////////////////////////////////
///                       Cocotb Verification Project                           ///
///                         4-bit Ripple Carry Adder                            ///
///////////////////////////////////////////////////////////////////////////////////
///   Full Adder                                                                ///
///   Copyright 2025 Ujval Madhu, All rights reserved                           ///
///////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: full_add,sv 1.0
//
//  $Date: 2025-28-02
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu

module full_adder(
    input a, b, cin,
    output sum, cout
);

wire c1, s1, c2;

half_adder ha1(
    .a(a),
    .b(b),
    .sum(s1),
    .carry(c1)
    );

half_adder ha2(
    .a(s1),
    .b(cin),
    .sum(sum),
    .carry(c2)
    );

assign cout = c1 | c2;

endmodule