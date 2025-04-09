///////////////////////////////////////////////////////////////////////////////////
///                                                                             ///
///                                 Test Class                                  ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///   Test Class Connecting the sequence with the testbench                     ///
///////////////////////////////////////////////////////////////////////////////////

class test extends uvm_test;
`uvm_component_utils(test)

    function new(input string name = "test", uvm_component c);
        super.new(name, c);
    endfunction

    env e;
    seq sq;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
        sq = seq::type_id::create("sq");
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        sq.start(e.a.sqr);
        #20
        phase.drop_objection(this);
    endtask

endclass