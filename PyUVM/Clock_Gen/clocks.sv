`timescale 1ns/1ps

module top(

    input clk1, clk2, clk3

);

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1,top);
end

endmodule