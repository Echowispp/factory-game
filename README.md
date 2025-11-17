# Space Colony Factory Game

##IF YOU SEE THIS WHEN REVIEWING W11, THIS COMMIT IS TOO NEW. Go to the earlier commit, named "the not final commit"

This a game where you build factories on a space colony
The goal of the game is to make a computer

<a href="https://echowispp.itch.io/2d-factory-game">Itch</a>

Controls: 
WASD movement
Click on a building at the top to select it, then click on the map to place it there! 
345 adjust zoom 
While hovering on a building, you can press 1 or 2 to change recipes, 1 is the recipe on the top of the building's recipe book and 2 is the one one the bottom

tech stack for this week is just and only that I fixed a bunch of bugs, though I will further elaborate what I think is the most interesting part of the game, which is the recipe system. It's pretty simple, too. It's just basic dictionary stuff. There's inputs, outputs and a process time. If there are enough inputs, the timer will start and when done. the outputs are put on the building output (miner has blank inputs, so it skips the input check). That's it. I'm absolutely fascinated by how simple dictionaries are, when I first thought of this project I thoguth the recipes would be the hardest part, but the real hardest part was moving stuff on conveyors. (I'm new to coding and only really used dictionaries once before, so this was a pleasant experience). I kinda forgot that last week. The rest of the systems are the opposite - pretty simple on paper, but they are the harder ones in reality. There might be an easier way to do them, though. This is just the way I used, which was difficult. 

## W11 STUFF BELOW
this is here mainly for easier comparison, the whole part is unmodified from the time it was first submitted

A game about collecting a big pile of gold

CONTROLS: WASD for movement, then you can click a button in the top left and place buildings down on stuff, that's it pretty much

tech stack:
basically, there's the sim_tick function that does everything, most of the code is there just to help it out. The buildings can be rotated, it does nothing without other buildings tho. 
About the order I've done stuff in, at first I did was adding some parameters and a basic skeleton to build the functionality off of. 
Then, I did the three parts of sim_tick: _move_tokens, _process_factories and _do_outputs. 
Then, I pretty much hopped around doing a line there, a line there and that for some time, which actually worked - for the amount of features I had time to implement. 
I will definitely be returning to this project on w11, though. 

My attempt at a written devlog:

A game about optimizing a grid-based factory... I might still go many ways with this game, but we'll see. I'll try to hold a sort-of devlog of how I'm thinking of each thing next on the todo list. In the end though, we'll see how well that goes

Already forgot to do this for a couple commits, but that... will surely be fine. 
(I just added some parameters I think will be useful for this, might end up adding some, deleting some, we'll see')

At the moment, I'm looking to do the functions inside sim_tick, starting with move_tokens. 
I'll likely end up using loops for them, basically checking how far each individual token has to move, 
then moving it. Btw I hope these "devlogs" (no idea what else to call them) will help with reviewing. 
And tokens represent resources, forgot to mention that earlier

Now, I'll do process_factories next, probably going to do a similar model with a loop for each individual factory
Same again with _do_outputs().

Now, I've added sprites and just realised I forgot to commit after adding the test sprites, which were just colored squares. Anyways, the sprites work now. 

I hope you like programmer art, I couldn't find any "real" assets for this project
