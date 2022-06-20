# Racing game

See https://www.lexaloffle.com/bbs/?pid=65926 for bezier curves
See https://www.lexaloffle.com/bbs/?tid=35767

Create a arbitary number of frames, say 100
Divide frames by speed (so speed of 100 would be 100/100 = 1, speed of 50 would be 2 and speed of 75 would be 1.33)

Then you say every x frames move the road.
Problem is the floating point math

So let's increase the arbitary frames to 1000 and use floor
We boost everything by 10 so 1000 / 75 = 13.333 but we can round it
Then you can have a timer that runs to some number, say 5000 and everytime 5000 % result == 0 we can update

OR when calculating the amount deduct number of frames from end
I mean if we are approaching 1000 and the number is about to roll over you need to deduct the overhead from the "amount"
