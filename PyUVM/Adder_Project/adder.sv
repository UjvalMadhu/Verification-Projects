`timescale 1ns/1ps
 
module adder(

    input [3:0] a, b,
    output [4:0] sum

);
 
    assign sum = a+b;

    always @(sum) begin

        $display("Sum is %d", sum);

    end
 
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1,adder);/// all the variables of specified module : mux
        #500;
        $finish;
    end
 
endmodule