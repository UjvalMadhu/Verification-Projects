`include "uvm_pkg.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;

    `uvm_object_utils_begin
        `uvm_field_int(addr, UVM_ALL_ON)         // used for complex datatypes int, array etc
    `uvm_object_utils_end

    function new(string name = "Cache_seq_item");
        super.new(name);
    endfunction

    constraints addr_align{
        addr[1:0] == 2'b00;
    }

endclass


class base_seq extends uvm_sequence #(transaction);
    `uvm_object_utils(base_seq)

    function new(string name = "Cache_seq");
        super.new(name);
    endfunction

    virtual task body();
        repeat(10) begin
            transaction tr;
            tr = transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize());
            finish_item(tr);
        end
    endtask
endclass


class wr_seq extends base_seq;
    `uvm_object_utils(wr_seq)

    function new (string name = "wr_seq");
        super.new(name);
    endfunction

    virtual task body();

        repeat (10) begin

            transaction tr_wr, tr_rd;
            bit [31:0] addr;
            bit [31:0] data;

            addr = $urandom & 32'hFFFFFFFC;
            data = $urandom;

            tr_wr = transaction::type_id::create("tr_wr");
            start_item(tr_wr);
            assert(tr_wr.randomize() with {
                rw == 0;
                addr == local::addr;
                wdata == local::data;
            });
            finish_item(tr_wr);


            tr_rd = transaction::type_id:;create("tr_rd");
            start_item(tr_rd);
            assert(tr_rd.randomize() with {
                rw == 1'b1;
                addr == local::data;
            });
            finish_item(tr_rd);

        end
    endtask

endclass


class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver)

    virtual inf vif;

    function new(string name = "driver", uvm_component parent = null);
        super.new(name);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
            `uvm_fatal("DRV", "ERROR instatiating virtual Interface");
    endfunction


    virtual task run_phase(uvm_phase);
        forever begin
            transaction tr;

            //Reset Signals

            seq_item_port.get_next_item(tr);

            driver_task(tr);

            seq_item_port.item_done();

        end
    endtask

    virtual task driver_task(transaction tr);
        // Access vif signals to set up conditions for driving sequence
    endtask
endclass



class monitor extends uvm_monitor;
// Same as driver, vif, build_phase

    uvm_analysis_port #(transaction) ap;

    function new(string name = "monitor", uvm_component parent = null);
        super.new(name);
        ap = new("ap", this);
    endfunction


    virtual task run_phase(uvm_phase phase);
        forever begin
            transaction tr;

            // create tr

            // capture vif signals into tr.signals

            ap.write(tr);
        end
    endtask
endclass


class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)

    uvm_analysis_imp #(transaction, scoreboard) aip;

    // DUT Model

    // Statistics
    int num_tr;
    int passes;
    int mismatches;

    function new(string name = "scoreboard", uvm_component parent = null);
        super.new(name);
        aip = new("aip", this);
        num_tr = 0;
        passes = 0;
        mismatches = 0;
    endfunction

    // If we want to initalize the memory model to zero use a for loop in the build phase
    // Use associative arrays to initialize memory as we can use mem.exists(tr.addr) to check if addr was initialized
    // bit [31:0] mem[int]; associative array


    virtual function void write(transaction tr);
        num_tr++;

        // Update model as per tr
        // Check model with tr values to verify correctness

    virtual function void report_phase(uvm_phase phase);

endclass


class agent extends uvm_agent;

    // instantiate driver, monitor
    uvm_sequencer #(transaction) seqr;

    function new(string name = "agent", uvm_component parent = null);
        super.new(name);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        monitor = monitor::type_id:;create("monitor", this);

        if (is_active == UVM_ACTIVE) begin
            driver = driver::type_id::create("driver", this);
            seqr = uvm_sequencer#(transaction)::type_id::create("sequencer", this);
        end
    endfunction

    function void connect phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction
endclass


// Env class
// Connect Scoreboard and monitor
    function void connect phase(uvm_phase phase);
        
        agent.monitor.ap.connect(scoreboard.aip);

    endfunction


