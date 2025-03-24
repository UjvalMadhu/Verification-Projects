///////////////////////////////////////////////////////////////////////////////////
///             Aynchronous Parameterized Fixed Priority Arbiter                ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///   TestBench Module                                                          ///
///   Reference: Rahul Behl, quicksilicon.in                                    ///
///   Copyright 2025 Ujval Madhu, All rights reserved                           ///
///////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: async_results_conv_test.v, v 1.0
//
//  $Date: 2024-28-12
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu

module test;

parameter num_ports = 5;
parameter num_tests = 100;

// Signals

logic [num_ports-1:0] req_i;
logic [num_ports-1:0] gnt_o;
int seed;


results_conv #(
    .num_ports(num_ports)
) top (
    .req_i(req_i),
    .gnt_o(gnt_o)
);

initial begin
    
    seed = $random;
    $srandom(seed); // Seeds the pseudorandom number generator

    // Random Request Generation
    for(int i = 0; i < num_tests; i++) begin
        req_i = {$random} % (1 << num_ports);
        #10;
        $display("Test %0d: req_i = %b, gnt_o = %b", i, req_i, gnt_o);
    end

end
endmodule
