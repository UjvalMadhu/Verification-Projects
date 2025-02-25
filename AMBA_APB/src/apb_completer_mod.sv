////////////////////////////////////////////////////////////////////////////////////
///                        UVM Verification Project                             ////
///                           AMBA APB5 Protocol                                ////
////////////////////////////////////////////////////////////////////////////////////
///   APB5 Peripheral Device or Completer module                                ////
///   Copyright 2025 Ujval Madhu, All rights reserved                           ////
////////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: apb_completer_mod.sv,v 1.0
//
//  $Date: 2025-01-30
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu



module apb_comp #(
    parameter int MEM_SIZE   = 256,    // Total Memory = 256*4 = 1024 Bytes
    parameter int DATA_WIDTH = 32,     // can be 8, 16, 32
    parameter int ADDR_WIDTH = 32      // Can be upto 32 bits
  )(
    apb_inf inf
  );

  // Memory array and Protection Support
  logic [DATA_WIDTH-1:0]  mem [0:MEM_SIZE-1];         // Each element of 0 to MEM_SIZE-1 can store DATA_WIDTH size value
  logic                   n_secure[0:MEM_SIZE-1];     // 0 = Secure, 1 = Non Secure

  // FSM States
  typedef enum logic [1:0]{
    IDLE   = 2'b00,
    SETUP  = 2'b01,
    ACCESS = 2'b10
  } ApbState;


  ApbState current_state, next_state;

  //Internal Signals
  logic    addr_aligned;
  logic    access_allowed;
  logic    not_secure_region;
  logic    device_busy;                              // can add logic to set wait for read and write

  
  // Address allignment check
  assign addr_aligned = (inf.completer_cb.paddr[1:0] == 2'b00);     // Checks if address is 4 byte aligned, example 0x0000, 0x0004, 0x0008...
                                                                    // address 0x0004 = mem[1], 0x0008 = mem[2]
                                                                    // mem[0] -> Stores bytes 0,1,2,3
                                                                    // mem[1] -> Stores bytes 4,5,6,7
                                                                    // mem[2] -> Stores bytes 8,9,A,B
                                                                    // mem[3] -> Stores bytes C,D,E,F
                                                                    // Each address from the requester should point to a byte in memory
  
  // Secure Access Check
  always_comb begin
      
    not_secure_region  = n_secure[inf.completer_cb.paddr[9:2]];     // Divides address by 4
    access_allowed     = 1'b1;

    if(inf.completer_cb.paddr[31:10] != 0)                          // Address out of Range              
      access_allowed = 1'b0;

    else if(inf.completer_cb.pprot[1] && !not_secure_region)        // Prevents non secure access from accessing secure memory
      access_allowed  = 1'b0;
    
    else if(!inf.completer_cb.pprot[1] && not_secure_region)        // Prevents secure access from accessing non secure memory 
      access_allowed  = 1'b0;

  end 


  //////// APB Completer State Machine //////// 

  always_ff @(posedge inf.pclk or negedge inf.preset_n) begin
    
    if(!inf.preset_n)
      current_state   <=  IDLE;
    else 
      current_state   <=  next_state;

  end

  // Next State Logic
  always_comb begin

    next_state = current_state;

    case(current_state)

      IDLE:   begin
                if(inf.completer_cb.psel && !inf.completer_cb.penable)
                  next_state        = SETUP;
              end

      SETUP:  begin
                  next_state        = ACCESS;
              end

      ACCESS: begin
                if(inf.completer_cb.pready) begin
                  if(!inf.completer_cb.psel)
                    next_state      = IDLE;
                  else
                    next_state      = SETUP;
                end
                else next_state     = ACCESS;
              end
      endcase

  end

  // Memory Access and Response 
  always_ff @(posedge inf.pclk or negedge inf.preset_n) begin
    
    if(!inf.preset_n) begin
      inf.completer_cb.prdata  <= {DATA_WIDTH{1'b0}};
      inf.completer_cb.pready  <= 1'b0; 
      inf.completer_cb.pslverr <= 1'b0;
      device_busy     <= 1'b0;

      // Initializing Memory and Protection Support
      for(int i = 0; i < MEM_SIZE; i++) begin
        
        mem[i]      <= i;
        n_secure[i] <= (i < MEM_SIZE/2);                    // First half of Memory is Secure

      end
    
    end

    else begin
      
      case(current_state)

        IDLE:   begin
                  inf.completer_cb.pready    <= 1'b0;
                  inf.completer_cb.pslverr   <= 1'b0;
                end

        SETUP:  begin
                  inf.completer_cb.pready <= 1'b0;    // Deassert for potential wait conditions, Also used for protocol timing when multiple transfers are present
                end

        ACCESS: begin
                  if(inf.completer_cb.psel && inf.completer_cb.penable) begin
                    inf.completer_cb.pslverr <= !(addr_aligned && access_allowed);

                    if(addr_aligned && access_allowed) begin
                      if(!device_busy) begin
                        if(inf.completer_cb.pwrite) begin
                
                          for(int i = 0; i < DATA_WIDTH/8; i++) begin
                            if(inf.completer_cb.pstrb[i])
                              mem[inf.completer_cb.paddr[ADDR_WIDTH-1:2]][i*8 +: 8] <= inf.completer_cb.pwdata[i*8 +: 8];
                          end
                          inf.completer_cb.pready  <= 1'b1;
                        end
                        else begin
                          inf.completer_cb.prdata <= mem[inf.completer_cb.paddr[ADDR_WIDTH-1:2]];
                          inf.completer_cb.pready  <= 1'b1;
                        end
                      end

                      else inf.completer_cb.pready <= 1'b0;

                    end

                    else inf.completer_cb.pready <= 1'b1;
                  end

                end
      
      endcase
    
    end

  end

endmodule : apb_comp