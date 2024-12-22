module timer_control(
    input clk,
    input reset,
    input pause,
    input [1:0] time_sel,      // to select specific time
    output reg [6:0] minutes = 0,
    output reg [6:0] seconds = 0,
    output reg done //flag for break to start
);
    reg [1:0] last_time_sel;  // Track the last time selection
    reg [31:0] cnt = 0;//100Mhz
    reg running = 0;
    reg pause_prev = 0;

    localparam TIMER_10_SEC = {7'd0, 7'd10};  // 10 seconds
    localparam TIMER_20_MIN = {7'd20, 7'd0};  // 20 minutes
    localparam TIMER_25_MIN = {7'd25, 7'd0};  // 25 minutes
    localparam TIMER_30_MIN = {7'd30, 7'd0};  // 30 minutes

    always @(posedge clk or negedge reset) begin
        if (~reset) begin
            minutes <=0;
            seconds <=0;
            cnt <= 0;
            running <= 0;
            pause_prev <= 0;
            done <= 0;
            
        end else begin
            if (time_sel != last_time_sel) begin //t-ff if the time is not equal to the previous time then updata the countdown
                update_countdown(time_sel);
                last_time_sel <= time_sel;  // Update last_time_sel
            end

            pause_prev <= pause;
            if (pause && !pause_prev) //t-ff to control when to stop and pause
            running <= ~running;//stop running when button is pressed another time

            if (running) begin
                cnt <= cnt + 1;//whenever there is a posedge clk, cnt increments 
                if (cnt >= 100000000) begin // 100MHz clock, after count reached 100 mill reset the count 
                    cnt <= 0;
                    if (seconds > 0) 
                    seconds <= seconds - 1; //decrement second till sec gets to 0 
                    else if (minutes > 0) begin
                        seconds <= 59;//reset the sec to 59 since a new minute is starting
                        minutes <= minutes - 1;
                    end else begin //when sec and min is zero
                        running <= 0; // Stop when reaching zero
                        done <= 1;//start flag rgb light 
                        end                       
                end
                else 
                    done <=0;
            end
        end
    end

    // this function do processing on the input and return one single value
    task update_countdown(input [1:0] time_sel);//based on the time_sel the timer start time is set
        case (time_sel)
            2'b00: {minutes, seconds} <= TIMER_10_SEC;
            2'b01: {minutes, seconds} <= TIMER_20_MIN;
            2'b10: {minutes, seconds} <= TIMER_25_MIN;
            2'b11: {minutes, seconds} <= TIMER_30_MIN;
            default: {minutes, seconds} <= TIMER_20_MIN;
        endcase
    endtask
endmodule