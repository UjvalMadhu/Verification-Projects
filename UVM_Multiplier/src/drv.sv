///////////////////////////////////////////////////////////////////////////////////
///                                                                             ///
///                              Driver Class                                   ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///   Driver that sends the transactions to the  Multiplier DUT                 ///
///////////////////////////////////////////////////////////////////////////////////

class drv extends uvm_driver # (transaction);
`uvm_component_utils(drv)

    transaction tr;
    virtual mul_if mif;

    function new(input string path = "drv", uvm_component parent = null);
        super.new(path, parent);
    endfunction


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual mul_if)::get(this, "", "mif", mif))
            `uvm_error("DRV", "Unable to access interface");
    endfunction


    virtual task run_phase(uvm_phase phase);
        tr = transaction::type_id::create("tr");
        forever begin
            seq_item_port.get_next_item(tr);
            mif.a = tr.a;
            mif.b = tr.b;
            `uvm_info("DRV", $sformatf("a: %0d, b:%0d, y: %0d",tr.a, tr.b, tr.y), UVM_MEDIUM);
            seq_item_port.item_done();
            #20;
        end
    endtask
endclass