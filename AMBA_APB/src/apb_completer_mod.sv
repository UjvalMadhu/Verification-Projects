////////////////////////////////////////////////////////////////////////////////////
///                        UVM Verification Project                             ////
///                           AMBA APB5 Protocol                                ////
////////////////////////////////////////////////////////////////////////////////////
///   APB5 Peripheral Device or Completer module                                ////
///   Copyright 2025 Ujval Madhu, All rights reserved                           ////
////////////////////////////////////////////////////////////////////////////////////
//  CVS Log
//
//  Id: apb_tb_top.sv,v 1.0
//
//  $Date: 2025-01-11
//  $Revision: 1.0 $
//  $Author:  Ujval Madhu



module apb_comp(
    apb_inf.comp apb_inf
  );

  // Memory array and Protection Support
  logic [31:0] mem [0:255];
  logic        n_secure[0:255];     // 0 = Secure, 1 = Non Secure

  // FSM States
  typedef enum logic [1:0]{
    IDLE   = 2'b00,
    SETUP  = 2'b01,
    ACCESS = 2'b10
  } ApbState;


  ApbState current_state, next_state;

  //Internal Signals
  logic         addr_aligned;
  logic         access_allowed;
  logic [31:0]  read_data;
  logic [3:0]   write_strobe;
  logic         in_secure_region;
  logic         device_busy;                              // can add logic to set wait for read and write

  
  // Address allignment check
  assign addr_aligned = (apb_inf.paddr[1:0] == 2'b00);    // Checks is address is 4 byte aligned, example 0x0000, 0x0004, 0x0008...

  
  
  // Secure Access Check
  always_comb begin
      
    not_secure_region  = secure[apb.paddr[7:0]];
    access_allowed     = 1'b1;

    if(apb_inf.pprot[1] && !not_secure_region)             // Prevents non secure access from accessing secure memory
      access_allowed  = 1'b0;
    
    else if(!apb_inf.pprot[1] && not_secure_region)        // Prevents secure access from accessing non secure memory 
      access_allowed  = 1'b0;

  end 


   // APB Completer State Machine
  always_ff @(posedge apb_inf.pclk or negedge apb_inf.preset_n) begin
    
    if(!apb_inf.preset_n)
      current_state   <=  IDLE;
    else 
      current_state   <=  next_state;

  end

  // Next State Logic
  always_comb begin

    next_state = current_state;

    case(current_state)

      IDLE:   begin
                if(apb.psel && !apb.penable)
                  next_state        = SETUP;
              end

      SETUP:  begin
                  next_state        = ACCESS;
              end

      ACCESS: begin

                if(apb_inf.pready) begin
                  if(!apb_inf.psel)
                    next_state      = IDLE;
                  else
                    next_state      = SETUP;
                end

                else next_state     = ACCESS;

      endcase

  end

  // Memory Access and Response
  always_ff @(posedge apb.pclk or negedge apb.preset_n) begin
    
    if(!apb.preset_n) begin
      apb_inf.prdata  <= 32'h0000_0000;
      apb_inf.pready  <= 1'b1; 
      apb_inf.pslverr <= 1'b0;
      device_busy     <= 1'b0;

      // Initializing Memory and Protection Support
      for(int i = 0; i < 256; i++) begin
        
        mem[i]    <= i;
        secure[i] <= (i < 128);

      end
    
    end

    else begin
      
      case(current_state)

        IDLE:   begin
                  apb_inf.pready    <= 1'b1;
                  apb_inf.pslverr   <= 1'b0;
                end

        SETUP:  begin
                  apb_inf.pready <= 1'b0;    // Deassert for potential wait conditions, Also used for protocol timing when multiple transfers are present
                end

        ACCESS: begin
                  if(apb_inf.psel && apb_inf.penable) begin
                    apb_inf.pslverr <= !(addr_aligned && access_allowed);

                    if(addr_aligned && access_allowed) begin
                      if(!device_busy) begin
                        apb_inf.pready  <= 1'b1;
                        if(apb_inf.pwrite) begin
                
                          for(int i = 0; i < 4; i++) begin
                            if(apb_inf.pstrb[i])
                              mem[apb.paddr[7:0]][i*8 +: 8] <= apb_inf.pwdata[i*8 +: 8];
                          end
                        end
                        else begin
                          apb_inf.prdata <= mem[apb_inf.paddr[7:0]];
                        end
                      end

                      else apb_inf.pready <= 1'b0;

                    end

                    else apb_inf.pready <= 1'b1;
                  end

                end
      
      endcase
    
    end

  end

endmodule : apb_comp