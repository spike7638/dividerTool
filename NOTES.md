I copied this from https://github.com/dusty-phillips/rescript-react-intro/tree/11366930496cb70ede8591548a9d6d432516d50b by downloading a zip file. ...and then fiddled a bit. 

Had to 
> npm install --global yarn 
as a first step. 

Then, in a terminal
> yarn install (took a while!)
because "yarn start" said "react-scripts not found"

This version now has 
(a) buttons (top row) that update a global value defined in Store.res
(b) buttons (middle row) that update another value, a sum of a locally-store value and the global value
(this computed value isn't used anywhere except to display as a label between the buttons)
(c) a ReProcessing program in which a square in the middle of a larger square has its size adjusted by any change in that global value controlled by the upper button-pair. 
=========================================
.Remove debugging output from editor

When when I change velues in the form does pressing the SVGResult button cause them to reset to defaults?

+make the "getSVG" button do what it's supposed to do.
start gluing "form" controls to editor
====

Write two beginner questions: 
1. Why no type-safety in assigning form data to Rescript variables? 
=========================================
The App (or something similarly high up -- the controls?) needs to maintain some state, i.e.
  1. All the stuff that the UI can change
  2. The current drawing (maybe ... yeah, because you could adjust the dip-factors mid-plan)


The Editor, on creation, needs to get a bunch of info from that state to establish things like the dot spacing, etc., 
AND needs to initialize its drawing from the locally-stored record of the drawing state. 

Whenever the drawing changes, update the drawing-state.
Make those local things like dot-spacing, etc., be part of the "state" of the reprocesssing window, so 
that they can be accessed as needed --- can't have them be module-level data as they are now. 