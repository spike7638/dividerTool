open Reprocessing;
// types
// "world-space point", i.e., pixel coordinates in GL. 
type ppoint = (float, float); //"Pixel point"

// "grid-space point", i.e., coordinates in the "dot grid", the preferred coord system
// Note that location (0,0), as a gpoint, is in the lower left of the drawing, 
// while (0., 0.), as a wpoint, is in the upper left, because OGL has y increase DOWNwards. Sigh.
type gpoint = {xi:int, yi:int};

type span = {p1:gpoint, p2:gpoint};

type stroke = {
  sp: span,
  color: colorT,
};

type drawing = list(stroke);

// =========================
// special mutable structure to preserve the stroke-list for use by other parts of the code
type ss = {mutable strokes:list(stroke)};

type feature =
  | CU(float) /* U and L and upper and lower features of a finger-joint; the upper piece on the CU side is long */
  | CL(float)
  | XU(float) /* Upper slit, i.e., the notch is cut in the BOTTOM half of the board */
  | XL(float) /* Lower slit, i.e., the notch is cut in the UPPER half of the board */
  | S(float) /* a slot */
  | T(float) /* a tab that fits into a slot */
  | G(float) /* a gap between panels */
  | D(float); /* an area that dips down by an amount specs.dipSize */

type specs = {
  height: float,
  dipSizeH: float,
  dipSizeV: float,
  t: float,
  pinCount: int, /* for one pin, divide height into 3 parts; for 3 tabs, divide into 5 */
  tabFraction: float /*  between 0 and 1 */
};

type point = (float, float); // point for SVG stuff
type boxSpec = {
  height: float,
  width: float,
  lowerLeft: point,
  isDip: bool /* disgusting hack; really should have "boxes" and "dips" and possibly "lineSegment"s too*/
};

type panelGeom = list(feature); 

type panel = {
  isHorizontal: bool,
  geom: panelGeom,
  name: string, 
}; /* horiz panels never contains CUs or XUs; vert panels never contain CLs or XLs */

type divider = {
  horiz: list(panel), /* horiz panels never contains CUs or XUs */
  vert: list(panel), /* vert panels never contain CLs or XLs   */
  spec: specs,
};

type settings = {
  counter: int, // add more later
  thickness: float,
  width: float,
  depth: float,
  height: float,
  spacing: float,
  includeEnclosure: bool,
  dipPercentageH: float,
  dipPercentageV: float,
 }

type state = {
  data: settings,
  svg: string,
  drawing: list(stroke),
  newStart: bool,
}
