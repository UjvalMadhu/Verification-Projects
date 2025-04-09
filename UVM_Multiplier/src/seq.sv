///////////////////////////////////////////////////////////////////////////////////
///                                                                             ///
///                              Sequence Class                                 ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///   Sequence to be driven on the Multiplier DUT                               ///
///////////////////////////////////////////////////////////////////////////////////

class seq extends uvm_sequence #(transaction);
`uvm_object_utils(seq)

    transaction tr;

    function new(input string path = "seq");
        super.new(path);
    endfunction

    virtual task body();
        repeat(10)
        begin
            tr = transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize());
            `uvm_info("SEQ", $sformatf("a:%0d, b:%0d, y:%0d", tr.a, tr.b, tr.y), UVM_NONE);
            finish_item(tr);
        end
    endtask
endclass