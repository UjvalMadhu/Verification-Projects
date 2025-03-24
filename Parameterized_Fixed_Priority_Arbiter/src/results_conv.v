///////////////////////////////////////////////////////////////////////////////////
///             Synchronous Parameterized Fixed Priority Arbiter                ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///   Top Module                                                                ///
///   Reference: Rahul Behl, quicksilicon.in                                    ///
///   Copyright 2025 Ujval Madhu, All rights reserved                           ///
///////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: results_conv.v, v 1.0
//
//  $Date: 2024-28-12
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu

module results_conv
    #(num_ports = 5)(
    input   clk_i,
    input   rst_ni,

    input       [num_ports-1:0] req_i,     // Request signal
    output  reg [num_ports-1:0] gnt_o      // Grant Signal
);

    // Internal Wire for grant
    wire [num_ports-1:0] gnt_nxt;


    // Combinatorial Logic for Grant generation

    assign gnt_nxt[0] = req_i[0];  // Highest Priority

    genvar i;
    generate
        for(i = 1; i < num_ports; i++) begin
            assign gnt_nxt[i] = req_i[i] & ~(|req_i[i-1:0]) ;    // Reduction Or makes checks all higher priorities
        end
    endgenerate

    
    // Sequential Logic for Output Reg

    always_ff @(posedge clk_i or negedge rst_ni) begin
    	
    	if(!rst_ni) begin
    		gnt_o <= {num_ports{1'b0}};  //Reset
    	end

    	else begin
			gnt_o <= gnt_nxt;    		
    	end
    end

endmodule