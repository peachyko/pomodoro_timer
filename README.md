# Pomodoro Timer

I made a Pomodoro timer , where I utilized UART for communication to select the specific time for the timer.
Pressing 0 would be for `10 seconds`, 1 for `20 minutes` which is usually how long the Pomodoro timer is, 2 for `25 minutes`, and 3 for `30 minutes`. 

After these timers are done, a `5 min break` is issued and we can see a green light on the RGB. On the LEDs, we can see which button is getting pressed.

If we want to change the countdown timer start time, we can press the read button to read the next value. 
The right button on the FPGA board is used to start and pause the timer. 
The CPU_reset button is used for reset.

### Block Diagram 
![image](https://github.com/Spring-2024-Classes/sp23-final-project-noodle/assets/127378367/804856e7-22cc-45a9-920d-ec86068c0de0)
