///////////////////////////////////////////////////////////////////////////////////
///                       Cocotb Verification Project                           ///
///                         4-bit Ripple Carry Adder                            ///
///////////////////////////////////////////////////////////////////////////////////
///   Half Adder                                                                ///
///   Copyright 2025 Ujval Madhu, All rights reserved                           ///
///////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: half_add,sv 1.0
//
//  $Date: 2025-28-02
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu

module half_adder(
    input a, b,
    output sum, carry
);

assign sum = a ^ b;
assign carry = a & b;

endmodule