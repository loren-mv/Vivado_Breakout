BREAKOUT
Lorenzo Moreira, Daniel Gergeus, Sulaiman Siddiqui, Astrid Elder
https://youtu.be/m5l5OtTNcuE?feature=shared


The game "Breakout", made in Verilog while building upon a previous project's code for "Pong".		
Breakout requires a keyboard for inputs and vga connection to a monitor from the FPGA (640x480).  Running “topmodule” will run the project. Inputs are taken from the keyboard. Levels selected using the numbers “1-8”, “A” and “D” are used to move the paddle left and right, and the spacebar to return to the menu screen.

Game modules instantiate and draw the required objects for each level. The objects “square”, “paddle”, and “block” contain logic to update their vector coordinates. “Square” and “block” contain logic to handle collisions, and the behavior of the objects upon collision.
“Keyboard_top” calls the required modules to take inputs from the keyboard, processes them, and outputs clean signals to select levels (a 4 bit number) or values for moving the paddle (single bit for each direction).
vga640x480 is a vga controller, that simply returns which exact pixel the vga is currently looking at. The sram module is responsible for reading the memory files that would display the level_select/menu/game_over screen. game_over.v, menu_screen.v and level_select.v call sram to read the respective memory file that will display the desired screens (that is not an instance of a game... i.e. levels 1-8). These 3 modules are really one and the same, except with slightly different logic combined with reading memory files. Important to note that these modules in particular were from the original EC311 Pong project, and were left mostly unchanged as to not completely alter game logic once work started being done in parallel.
anim_clockdivider is just a clock divider that sets the clock for the flashing "START GAME" and "GAME OVER" on the menu screen and the game over screen. 
scoretrack keeps track of current score/highscore per level.
segFSM 7segment display logic that shows where/how to display an arbitrary numerical input (in our case, the score).
scoreto7seg puts score onto 7segment display. combines scoretrack and segFSM.






