///////////////////////////////////////////////////////////////////////////////////
///             Aynchronous Parameterized Fixed Priority Arbiter                ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///   Top Module:  Asynchronous Design                                          ///
///   Reference: Rahul Behl, quicksilicon.in                                    ///
///   Copyright 2025 Ujval Madhu, All rights reserved                           ///
///////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: async_results_conv.v, v 1.0
//
//  $Date: 2024-28-12
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu

module results_conv
    #(num_ports = 5)
    (
    input   wire[num_ports-1:0] req_i,     // Request signal
    output  wire[num_ports-1:0] gnt_o      // Grant Signal
);

    assign gnt_o[0] = req_i[0];  // Highest Priority

    genvar i;
    generate
        for(i = 1; i < num_ports; i++) begin
            assign gnt_o[i] = req_i[i] & ~(|req_i[i-1:0]) ;    // Reduction Or makes checks all higher priorities
        end
    endgenerate

endmodule