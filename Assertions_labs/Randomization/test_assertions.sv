// Immediate Assertions

always @(posedge clk)
begin
    if(a)
    begin
        @(posedge d)
        Assertion_Name : assert (b || C) $display("Assertion Passed\n")
        else $fatal("Assertion Error\n")
    end
end


// Concurrent Assertions
property request_grant;
    @(posedge clk)
    req ##1 gnt;
endproperty

A1: assert property (request_grant)
    $info("Request Followed by Grant");
else
    $error("Grant not received after request")


// Combined Representation

A2 : assert property (@(posedge clk) disable iff (!rst_n) 
            (en1 || en2);
    $info("Read Write Check Passed");
else
    $error("Read Write Error");



property seq;
    @(posedge clk) 
        a ##1 b ##1 c;              // A must be high at the positive edge of clk, then in the next cycle B must be high and
endproperty                         // in the next cycle C must be high.




property seq2;
    @(posedge clk) disable iff (!rst_n)   // Property checking off if rst_n is low,
        a ##1 b ##1 c ##1 |=> a;          // if A is high, then B is high and the C is high in consecutive cycles,
endproperty                               // Then A must be High on the cycle that follow C


// Consecutive repetitions: (a ##1 b)[*2]   =   (a ##1 b) ##1 (a ##1 b)
// Consecutive repetitions in range: a[*1:2]  =  (a ##1 a)   or   (a ##1 a ##1 a)