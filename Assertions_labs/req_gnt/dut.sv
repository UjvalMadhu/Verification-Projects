

module dut(
    input clk,
    input rst_n,
    input req,
    output gnt 
    );

    typedef enum logic[2:0] {IDLE, STATE1, STATE2, STATE3, STATE4, STATE5} state_t;
    state_t current_state, next_state;

    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            current_state <= IDLE;
            gnt <= 1'b0;
        end
        else begin
            current_state <= next_state;
        end
    end

    always_comb begin

        next_state = current_state;
        gnt = 1'bx;

        case (current_state)
        IDLE: begin
            if(req) begin
                next_state = STATE1;
            end
        end
        STATE1: begin
            if(!clk) begin
                gnt <= 1'b0;
                next_state <= STATE2;
            end
        end
        STATE2: begin
            if(!clk) begin
                gnt <= 1'b1;
                next_state <= STATE3;
            end
        end
        STATE3: begin
            if(req) begin
                next_state <= STATE4;
            end
        end
        STATE4: begin
            if(!clk) begin
                gnt <= 1'b0;
                next_state <= STATE5;
            end
        end
        STATE5: begin
            if(!clk) begin
                gnt <= 1'b0;
                next_state <= IDLE;
            end
        end

    end

endmodule
