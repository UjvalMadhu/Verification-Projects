///////////////////////////////////////////////////////////////////////////////////
///                                                                             ///
///                           Scoreboard Class                                  ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///   For checking the output of the DUT                                        ///
///////////////////////////////////////////////////////////////////////////////////

class scb extends uvm_scoreboard;
    `uvm_component_utils(scb)
    uvm_analysis_imp #(transaction, scb) recv;

    function new(input string name = "sco", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        recv = new("recv", this);
    endfunction


    virtual function void write(transaction tr);
        if(tr.y == tr.a * tr.b) begin
            `uvm_info("SCB", $sformatf("Test Passed: a: %0d, b: %0d, y:%0d", tr.a, tr.b, tr.y), UVM_MEDIUM);
        end
        else begin
            `uvm_error("SCB", $sformatf("Test Passed: a: %0d, b: %0d, y:%0d", tr.a, tr.b, tr.y));
        end
    endfunction

endclass 