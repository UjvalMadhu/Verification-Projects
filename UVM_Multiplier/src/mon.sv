///////////////////////////////////////////////////////////////////////////////////
///                                                                             ///
///                              Monitor Class                                  ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///   For monitoring transactions from the Multiplier DUT                       ///
///////////////////////////////////////////////////////////////////////////////////

class mon extends uvm_monitor #(transaction);
`uvm_component_utils(mon)

uvm_analysis_port#(transaction) send;
virtual mul_if mif;
transaction tr;

    function new(input string inst = "mon", uvm_component parent = null);
        super.new(inst, parent);
    endfunction 

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        send = new("send", this);
        if(!uvm_config_db#(virtual mul_inf)::get(this, "", "mif", mif))
            `uvm_error("MON", "Unable to access interface");
    endfunction

    virtual task run_phase(uvm_phase phase);
        tr = transaction::type_id::create("tr");
        forever begin
            #20
            tr.a = mif.a;
            tr.b = mif.b;
            tr.y = mif.y;
            `uvm_info("MON", $sformatf("a: %0d, b: %0d, y: %0d", tr.a, tr.b, tr.y), UVM_MEDIUM);
            send.write(tr);
        end
    endtask

endclass
