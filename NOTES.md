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
