STATIC_FAILURE EXPLANATION

The file calculates the diameter of the off-set shaft to avoid failure using DET failure theory. Changes need to made to the USER INPUT SECTION. 

N is the factor of safety from the handout
L is the user defined length of the shaft
Guess is an initial diameter guess to start the iteration. 
Sy is the static yield strength from the material the user chooses. 

Fy1 and Fz1 represent the applied forces from gear 1. Fy2 and Fz2 for gear 2.

gDia1 is the users chosen diameter for gear 1
gDia2 is the users chosen diameter for gear 2

xPosGr1 is the x-position of of the first gear.
xPosGr2 is the position of gear 2. 

The rest of the file uses statics, and DET to calculate the desired diameters


FATIGUE_FAILURE EXPLANATION

This portion is stil being worked on.