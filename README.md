# factory-game
##UNFINISHED PROJECT
A game about optimizing a grid-based factory... I might still go many ways with this game, but we'll see. I'll try to hold a sort-of devlog of how I'm thinking of each thing next on the todo list. In the end though, we'll see how well that goes

<a href="https://echowispp.itch.io/2d-factory-game">Itch</a>

So, there's not much to this project, there's basically the code. I don't have time for any more changes really so... yeah. Sorry for few commits and also forgetting to keep up this log or whatever you'd call it. 

tech stack:
basically, there's the sim_tick function that does everything, most of the code is there just to help it out. The buildings could be rotated, if they could be placed. About the order I've done stuff in, at first I did was adding some parameters and a basic skeleton to build the functionality off of. Then, I did the three parts of sim_tick: _move_tokens, _process_factories and _do_outputs. then, I pretty much hopped around. doig a line there, a line there and that for some time, which actually worked - when I tried it with test functions. I never got the manual placing working, though. 

My attempt at a written devlog:

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
