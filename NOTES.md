I copied this from https://github.com/dusty-phillips/rescript-react-intro/tree/11366930496cb70ede8591548a9d6d432516d50b by downloading a zip file. ...and then fiddled a bit. 

Had to 
> npm install --global yarn 
as a first step. 

Then, in a terminal
> yarn install (took a while!)
because "yarn start" said "react-scripts not found"
=========================================

.Whenever the drawing changes, update the drawing-state [20 min]
** .extract the drawing from the editor when the SVG button is pressed,
** .put a printed version of it in the SVG window. [20 min]
.Convert that extracted drawing into SVG [3 hour]
.* Simplify initial settings for testing
.* Add an SVG HTML element "block" to display the SVG directly
.* Vertical and Horizontal overwrite each other in SVG
.* .Perhaps turn off the stroke-list debugging (line 419; search for showStrokes)
.* Need to copy initial stroke-set to "sharing" thing at the start (or trigger a refresh there, if it's already right)
x* ?Turn off "outer box" for initial testing
.* Insert linebreaks in SVG!
.* Adjust SVG TEXT display to limited 5-line height (currently applied to SVG drawing!)
.* Fix the code so that horizontal strokes use "L" instead of "U", and vice-versa

* Generate blue, thicker lines along with red, thin, lines, and green panel-labels; add grouping.
* Need to fix the geometry calculations for a 900 x 900 display, and an 8 x 7 grid with 0.5" spacing the underlying drawer-shape is drawn too large

* Clean up all code to remove leftover bits, document what's going on, etc. 
* Figure out how to clean up the build process so that it all works properly. Switch everything to rescript? 
* it'd be nice to trigger an update to the svg stuff at the very start. 
