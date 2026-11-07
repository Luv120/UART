module reciever(data_r,rx,baud_div,clk,reset);
    input rx;
    input[8:0] baud_div;
    input clk;
    input reset;
    output reg[7:0] data_r;
    parameter IDLE=3'b000, START=3'b001, DATA=3'b010, PARITY=3'b011, STOP=3'b100;
    reg[2:0] state;
    reg[3:0] bit_counter;
    reg[8:0] baud_counter;

    
    always @(posedge clk)
        if(reset) begin
            state<=IDLE;
            bit_counter<=4'd0;
            data_r<=8'd0;
            baud_counter<=9'd0;
        end
        else begin
            case(state)
                IDLE: begin
                    bit_counter<=4'd0;
                    if(rx==1'b0) begin 
                            state<=START;
                            baud_counter<=9'd0;
                      end 
                end
                START: begin
                    if(baud_counter == (baud_div/2)-1) begin
                        if(rx == 1'b0) begin
                            state <= DATA;
                            baud_counter <= 9'd0;
                        end
                        else begin
                            state <= IDLE;
                            baud_counter <= 9'd0;
                        end
                    end
                    else begin
                        baud_counter<=baud_counter+1;
                    end
                end
                DATA: begin
                    if(baud_counter == baud_div-1) begin
                        data_r <= {rx, data_r[7:1]};
                        baud_counter <= 9'd0;

                        if(bit_counter == 4'd7)
                            state <= PARITY;
                        else begin
                            bit_counter <= bit_counter + 1;
                            state <= DATA;
                        end
                    end
                    else begin
                        baud_counter<=baud_counter+1;
                    end
                end    
                    
                PARITY: begin
                    if(baud_counter==(baud_div)-1) begin
                        if(rx==^data_r) begin
                            state<=STOP;
                            baud_counter<=9'd0;
                        end
                        else begin
                            state<=IDLE;
                            baud_counter<=9'd0;
                        end
                    end
                    else begin
                        baud_counter<=baud_counter+1;
                    end
                end

                STOP: begin
                    if(baud_counter==(baud_div)-1) begin
                        if(rx == 1'b1) begin
                            state <= IDLE;
                            baud_counter<=9'd0;
                        end
                        else begin
                            state <= IDLE;
                            data_r <= 8'd0;
                        end
                    end
                    else begin
                        baud_counter<=baud_counter+1;
                    end
                    
                end
                default: state<=IDLE;
            endcase

        end
    
endmodule
