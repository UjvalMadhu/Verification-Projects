`timescale 1ns/1ps

module top;

    logic clk;
    logic reset;
    logic enable;
    logic [3:0] count;

    counter dut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .count(count)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("Starting counter testbench");
        reset = 1;
        enable = 0;
        #10 reset = 0;
        #10 enable = 1;
        #100 $finish;
    end

    initial begin
        $monitor("Time =%0t, count = %0d", $time, count);
    end

endmodule