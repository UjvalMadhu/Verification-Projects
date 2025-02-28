////////////////////////////////////////////////////////////////////////////////////
///                       Cocotb Verification Project                           ////
///                               8x1 MUX                                       ////
////////////////////////////////////////////////////////////////////////////////////
///   Top Module: Standard 8x1 MUX design                                       ////
///   Copyright 2025 Ujval Madhu, All rights reserved                           ////
////////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: mux8x1.py,v 1.0
//
//  $Date: 2025-28-02
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu

module mux(
    input en,
    input [7:0] din,
    input [2:0] sel,
    output reg dout
);


// Combinatorial Logic Block

always @ (*) begin

    dout = 1'b0;
    if(en) begin 
        case(sel)

            3'd000: dout = din[0];
            3'd001: dout = din[1];
            3'd010: dout = din[2];
            3'd011: dout = din[3];
            3'd100: dout = din[4];
            3'd101: dout = din[5];
            3'd110: dout = din[6];
            3'd111: dout = din[7];

            default: dout = 1'b0;

        endcase
    end

end

// waveform gen
initial begin

    $dumpfile("dump.vcd");
    $dumpvars(1,mux);

end

endmodule