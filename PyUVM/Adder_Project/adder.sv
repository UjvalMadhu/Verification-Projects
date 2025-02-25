`timescale 1ns/1ps
 
module mux(
input [3:0] addr, din,
output reg full
);
 
initial begin
full = 1'b0;
#450;
full = 1'b1;
end
 
 
initial begin
$dumpfile("dump.vcd");
$dumpvars(1,mux);/// all the variables of specified module : mux
#500;
$finish;
end
 
endmodule