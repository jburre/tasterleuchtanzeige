an assembly program for realizing 
traffic signals. The user can push a pin and the
signal for the traffic changes to red and for the others
to green and then back again.

---------------------------------------------
The code was realized as part of the course 
"Rechnerstrukturen" at the FH Lübeck.
The underlying hardware was an ATMEGA644PA chip.

-----------------------------------------------
Since I did not know how to correctly implement a
request if a pin was pushed I realized it as a 
loop that pings the corresponding pin and waits
in the state "green for cars" until the pin was pushed.
Therefore it can NOT respond to a pushed pin until
the state "green for cars" is reached again.

