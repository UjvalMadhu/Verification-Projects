///////////////////////////////////////////////////////////////////////////////////
///                                                                             ///
///                         Testbench Top Module                                ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///  Top module of the testbench                                                ///
///////////////////////////////////////////////////////////////////////////////////

module tb;

    mul_if mif();

    mul dut(.a(mif.a), .b(mif.b), .y(mif.y));

    initial begin
        uvm_config_db #(virtual mul_if)::set("this", "*", "mif", mif);
        run_test("test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule