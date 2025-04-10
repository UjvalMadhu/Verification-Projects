///////////////////////////////////////////////////////////////////////////////////
///                                                                             ///
///                              Agent Class                                    ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///   Connecting together the subclasses of the Testbench                       ///
///////////////////////////////////////////////////////////////////////////////////

class agt extends uvm_agent;
    `uvm_component_utils(agt);

    function new(input string name = "agt", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    drv d;
    uvm_sequencer #(transaction) seqr;
    mon m;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        d = drv::type_id::create("d", this);
        m = mon::type_id::create("m", this);
        seqr = uvm_sequencer #(transaction)::type_id::create("seqr", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        d.seq_item_port.connect(seqr.seq_item_export);
    endfunction

endclass
