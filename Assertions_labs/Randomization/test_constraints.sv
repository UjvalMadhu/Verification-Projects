typedef enum logic {
   dir_rd = 1'b0,
   dir_wr = 1'b1
} T_dir;

typedef logic [31:0] T_addr;
typedef logic [31:0] T_data;

class Bus_trans;
    rand T_dir dir;
    rand T_addr addr;
    rand T_data data;

endclass

typedef enum {
        ROM,
        RAM,
        IO
    } area;

class Mem_map extends Bus_trans;
    rand area area_map;

    constraint address_map {
        area_map == ROM -> addr inside {['h0000:'h7FFF]};
        area_map == RAM -> addr inside {['h8000:'hDFFF]};
        area_map == IO -> addr inside {['hE000:'hFFFF]};
    }

    constraint ROM_read_only { 
        area_map == ROM -> dir == dir_Rd; 
    }
endclass