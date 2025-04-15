///////////////////////////////////////////////////////////////////////////////////
///                                                                             ///
///                           Parameterized FIFO                                ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///   This is a Synthesizable Parametrized FIFO  Design                         ///
///                                                                             ///
///    Parameters:                                                              ///
///    DATA_WIDTH : Width of the data bus in bits                               ///     
///    DEPTH : Number of elements the FIFO can store                            ///
///                                                                             ///
///   Copyright (C) 2025 Ujval Madhu,                                           ///
///   This program is free software: you can redistribute it and/or modify      ///
///   it under the terms of the GNU General Public License as published by      ///
///   the Free Software Foundation, either version 3 of the License, or         ///
///   (at your option) any later version.                                       ///
///                                                                             ///
///   This program is distributed in the hope that it will be useful,           ///
///   but WITHOUT ANY WARRANTY; without even the implied warranty of            ///
///   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the             ///
///   GNU General Public License for more details.                              ///
///                                                                             ///
///   You should have received a copy of the GNU General Public License         ///
///   along with this program.  If not, see <https://www.gnu.org/licenses/>.    ///
///                                                                             ///
////////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: fifo.sv, v 1.0
//
//  $Date: 2025-4-12
//  $Revision: 1.0 
//  $Author:  Ujval Madhu


module fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 16         // Should be >= 1
)(
    input logic clk,
    input logic rst_n,

    // Write interface
    input   logic wr_en,
    input   logic [DATA_WIDTH-1:0] data_in,
    output  logic full,

    // Read Interface
    input   logic rd_en,
    output  logic [DATA_WIDTH-1:0] data_out,
    output  logic empty
);

    localparam int ADDR_WIDTH = (DEPTH == 1) ? 1 : $clog2(DEPTH);
    localparam int CNT_WIDTH  = $clog2(DEPTH + 1);

    
    // Internal Signals and Memory

    logic [DATA_WIDTH-1:0] mem [DEPTH];       // Fifo Memory
    logic [ADDR_WIDTH-1:0] wr_ptr;
    logic [ADDR_WIDTH-1:0] rd_ptr;
    logic [CNT_WIDTH-1:0] count;

    logic write_allow;
    logic read_allow;


    // Combinational Logic

    assign full     = count == DEPTH;
    assign empty    = count == 0;

    assign write_allow  = wr_en && !full;
    assign read_allow   = rd_en && !empty;

    assign data_out = mem[rd_ptr];   // Memory Read, Allows for better latency which is desirable in FIFOs, but valid only when !empty

    // Sequential logic

    // Memory write and read logic
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n):
            for(int i = 0; i < DEPTH; i++) begin
                mem[i] <= {DATA_WIDTH{1'b0}};
            end
        else begin
            if(write_allow) begin
                mem[wr_ptr] <= data_in;
            end
        end

    end

    // Pointer and Counter Logic
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            wr_ptr <= {ADDR_WIDTH{1'b0}};
            rd_ptr <= {ADDR_WIDTH{1'b0}};
            count  <= {CNT_WIDTH{1'b0}};
        end
        else begin
            wr_ptr <= wr_ptr;
            rd_ptr <= rd_ptr;
            count  <= count;

            case({write_allow,read_allow})
                2'b11: begin
                    wr_ptr <= (wr_ptr == DEPTH - 1) ? {ADDR_WIDTH{1'b0}} : wr_ptr + 1;
                    rd_ptr <= (rd_ptr == DEPTH - 1) ? {ADDR_WIDTH{1'b0}} : rd_ptr + 1;  // Count remains the same
                end
                2'b01: begin
                    rd_ptr <= (rd_ptr == DEPTH - 1) ? {ADDR_WIDTH{1'b0}} : rd_ptr + 1;
                    count <= count - 1;
                end
                2'b10: begin
                    wr_ptr <= (wr_ptr == DEPTH - 1) ? {ADDR_WIDTH{1'b0}} : wr_ptr + 1;
                    count <= count + 1;
                end
                2'b00: begin
                    // No Function
                end
                default: ;
            endcase
        end
    end
endmodule