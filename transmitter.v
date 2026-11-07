module transmitter(tx,data,clk,tx_start,baud_div,reset);
    input[7:0] data;
    input clk;
    input reset;
    input tx_start;
    input[8:0] baud_div;
    output reg tx;
    parameter IDLE=3'b000, START=3'b001, DATA=3'b010, PARITY=3'b011, STOP=3'b100;
    reg[2:0] state;
    reg[3:0] bit_counter;
    reg baud_tick;
    reg[8:0] baud_counter;

    always @(posedge clk)
    begin
        if(reset) begin
            baud_counter<=9'd0;
            baud_tick<=1'b0;
        end
        else begin
        if(baud_counter==baud_div-1) begin
            baud_counter<=9'd0;
            baud_tick<=1'b1;
        end
        else begin
            baud_counter<=baud_counter+1;
            baud_tick<=1'b0;
        end
        end
    end

    always @(posedge clk)
    if(reset) begin
        state<=IDLE;
        bit_counter<=4'd0;

    end
    else begin
    begin
        case(state)
            IDLE: begin bit_counter<=4'd0; state<= tx_start?START:IDLE; end
            START: if(baud_tick) state<= DATA;
            DATA: if(baud_tick) begin if(bit_counter==4'd7) state<=PARITY;
                else begin bit_counter<=bit_counter+1;
                state<=DATA; 
                end
            end
            PARITY: if(baud_tick) state<=STOP;
            STOP: if(baud_tick) state<=IDLE;
            default: state<=IDLE;
        
        endcase
    end
    end

    always @(*) begin
        case(state)
            IDLE: tx=1'b1;
            START: tx=1'b0;
            DATA: tx=data[bit_counter];
            PARITY: tx=^data;
            STOP: tx=1'b1; 
            default: tx=1'b1;
        endcase
    end
endmodule



