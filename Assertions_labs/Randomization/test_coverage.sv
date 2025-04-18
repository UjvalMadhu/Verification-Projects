// Simple Covergroup for tracking address:
covergroup transaction_coverage;
    coverpoint transaction.addr {
        bins low_addr  = {[0:255]};
        bins high_addr = {[512:1023]};
        bins default others  = default;
    }
endgroup

// Conditional Coverpoints 
covergroup transaction_coverage;
    coverpoint transaction.addr iff (arb_en) {       // Tracks coverpoint only if arb is enabled
        bins low_addr  = {[0:255]};
        bins high_addr = {[512:1023]};
        bins default others  = default;
    }
endgroup

// Illegal bins, Ignore bins
covergroup valid_addr_coverage;
    coverpoint transaction.addr{
        bins valid_range = {[0:255]};
        ignore_bins reserved_values = {10,20,30, [100:119]};    // Does not keep track of these
        illegal_bins out_of_range = {[256:$]};   // If this is hit, simulation can issue a warning or error
    }
endgroup

// Cross Coverage
covergroup addr_coverage;
    coverpoint transaction.addr{
        bins low_addr = {[0:255]};
        bins high_addr = {[256:512]};
    }
    coverpoint transaction.data{
        bins data_low = {[0:15]};
        bins data_high = {[16:31]};
    }
    cross data_addr_coverage : transaction.addr, transaction.data{
        bins data_low_addr_low = binsof(transaction.data.data_low) cross binsof(transaction.addr.addr_low);
        bins data_high_addr_high = binsof(transaction.data.data_high) cross binsof(transaction.addr.addr_high);
        bins others = deafult;
    }
endgroup
