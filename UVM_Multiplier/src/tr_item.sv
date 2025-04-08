///////////////////////////////////////////////////////////////////////////////////
///                                                                             ///
///                   Transaction Class: Sequence Item                          ///
///                                                                             ///
///////////////////////////////////////////////////////////////////////////////////
///   Sequence Item for driving the stimulus                                    ///
///////////////////////////////////////////////////////////////////////////////////

class transaction extends uvm_sequence_item;
`uvm_object_utils(transaction)

    rand bit [3:0] a;
    rand bit [3:0] b;
    bit [7:0] y;

    function new(input string path = "transaction");
        super.new(path);
    endfunction

endclass