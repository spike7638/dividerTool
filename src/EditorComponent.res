open Reprocessing;
open Reprocessing_Utils;
open Types


/* Store data structures 
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
  drawing: list<stroke>,

// ===== end of Store data structures
*/
// =========================
// special mutable structure to preserve the stroke-list for use by other parts of the code


type sl = list<stroke>;

type ss = {mutable strokes: list<stroke>};
let dataCarrier:ss = {strokes: list{}};
let getStrokes:unit => drawing = () => dataCarrier.strokes;
// =========================


type phase = Base | Shift | DelStart | DelDone | Neutral | Dragging
type drawingGeometry = {wCount: int, hCount:int, dotSpacing:int, frameHeightPixels:int, frameWidthPixels:int};

type stateT = { 
  p : phase,
  dragging: bool,
  dragStart: gpoint,
  dragNow: gpoint,
  strokeColor: colorT,
  strokeList: list<stroke>,
  dots: list<gpoint>,
  oldStrokes: list<stroke>,
  dg: drawingGeometry,
};



let toString: stroke => string = s => {
  let soi = string_of_int; 
  "p1: " ++ soi(s.sp.p1.xi) ++ ", " ++ soi(s.sp.p1.yi) ++ "; " ++
  "p2: " ++ soi(s.sp.p2.xi) ++ ", " ++ soi(s.sp.p2.yi)
}

let rec stringOfStrokes = (label, strokes) => {
  switch(strokes){
    | list{} =>   label++"\n---\n"
    | list{hd, ... tl} => stringOfStrokes(label ++ "\n" ++ toString(hd), tl)
  }
} 



@react.component
let make = (~state: Types.state , ~dispatch: Store.action => unit) => {  
  let id = "divider-editor"

  if (false) { dispatch(Store.NoOp)} else {()} // placed here to silence warnings about dispatch being unused.
 
//let setup = Editor.setup;
// (env) => {
//   Env.size(~width=200, ~height=200, env);
// };

//let draw = Editor.draw;
// (_state, env) => {
//   Draw.background(Constants.red, env);
//   Draw.fill(Constants.green, env);
//   Draw.rect(~pos=(50, 50), ~width=100, ~height=100, env)
// };


//==============================================================================================
 


// constants: physical layout/styling
let displayWidth = 900; // pixels
let displayHeight = 900; // pixels
let margin = 20; // pixels
let dotRadius = 2.5;
let lineWidth = 2; 
let frameLineWidth = 7;
let randomStrokeColors = true;

// constants: colors 
let bgColor = color(~r=255, ~g=250, ~b=250, ~a=255);
let basicStrokeColor = color(~r=90, ~g=160, ~b=245, ~a=255);
let dragLineColor = color(~r=205, ~b=0, ~g=0, ~a=255);
let dotColor = color(~r=0, ~g=0, ~b=0, ~a=255);
let frameColor = color(~r=200, ~g=200, ~b=0, ~a=55);

// =======================================

//let frameWidth = 65.0; // inch
//let frameHeight = 85.0; // inch
//let dotGap = 10.0; // inch

// the amount of space, in inch, needed for the divider PLUS an extra row or col of dots if 
// needed. 
// let extendedWidth =  dotGap *. ceil(frameWidth /. dotGap);
// let extendedHeight = dotGap *. ceil(frameHeight /. dotGap);


// let ratio = min(float_of_int(displayWidth-2*margin) /. extendedWidth,
//                float_of_int(displayHeight-2*margin) /. extendedHeight); // units are pixels/inch

// let dotSpacing = int_of_float(ratio *. dotGap); // units are pixels.

// let wCount = 1 + int_of_float( ceil(frameWidth /. dotGap));
// let hCount = 1 + int_of_float( ceil(frameHeight /. dotGap));

// let frameHeightPixels = int_of_float(floor(ratio *. frameHeight));
// let frameWidthPixels = int_of_float(floor(ratio *. frameWidth));


let rColor: unit => colorT =
  () => {
    let rb: unit => int = () => random(~min=0, ~max=255);

    color(~r=rb(), ~g=rb(), ~b=rb(), ~a=255);
  };

let wToG: (stateT, ppoint) =>  gpoint =
  (s, (x, y)) => {
    {
      xi:
        int_of_float(
          round((x -. float_of_int(margin)) /. float_of_int(s.dg.dotSpacing)),
        ),
      yi:
        int_of_float(
          round(
            (float_of_int(displayHeight) -. y -. float_of_int(margin))
            /. float_of_int(s.dg.dotSpacing),
          ),
        ),
    };
  };


let gToW: (stateT, gpoint) => ppoint = (s, g) => 
{
  (float_of_int(g.xi * s.dg.dotSpacing + margin), float_of_int(displayHeight - (g.yi * s.dg.dotSpacing + margin)));
}
 

let makeOuterStrokes: (drawingGeometry) => list<stroke> =
  dg => {
    let left = 0;
    let top = 0;
    let right = dg.wCount - 1;
    let bot = dg.hCount -1;

    list{
      {sp: {p1: {xi:left, yi:top}, p2: {xi:left, yi:bot}}, color: rColor()},
      {sp: {p1: {xi:left, yi:bot}, p2: {xi:right, yi:bot}}, color: rColor()},
      {sp: {p1: {xi:right, yi:bot}, p2: {xi:right, yi:top}}, color: rColor()},
      {sp: {p1: {xi:right, yi:top}, p2: {xi:left, yi:top}}, color: rColor()},
    };
  }; 

// generate a sequence of ints from first to last-1, inclusive.
let rec intSegment: (int, int, list<int>) => list<int> =
  (first, last, current) =>
    if (first == last) {
      current;
    } else {
      list{first, ...intSegment(first + 1, last, current)};
    };


// make a list wCount x hCount (i,j) pairs ranging from 
// (0,0) to (wCount-1, hCount-1)
let makeDots: drawingGeometry => list<gpoint> =
 dg => { 
    let xs = intSegment(0, dg.wCount, list{});
    let ys = intSegment(0, dg.hCount, list{});

    let h = x => List.map(u => {xi:x, yi:u}, ys);
    let dl = List.flatten(List.map(h, xs));
    dl;
  };

let nonDegenerate:stroke => bool = s => {
   !(s.sp.p1 == s.sp.p2)
};

let orderY: stroke => stroke = s => { 
  if (s.sp.p1.yi < s.sp.p2.yi) { s }else{
    {...s, sp: {p1:s.sp.p2, p2: s.sp.p1}}
  }
};

let orderX: stroke => stroke = s => { 
  if (s.sp.p1.xi < s.sp.p2.xi) { s } else{
    {...s, sp:{p1:s.sp.p2, p2: s.sp.p1}}
  }
};
 
let compXY: (stroke, stroke) => int = (s1, s2) => {
  let dx = compare(s1.sp.p1.xi, s2.sp.p1.xi);
  let dy = compare(s1.sp.p1.yi, s2.sp.p1.yi);
  if (dx == 0) {
    dy
  } else {
    dx
  }
};

let compYX: (stroke, stroke) => int = (s1, s2) => {
  let dx = compare(s1.sp.p1.xi, s2.sp.p1.xi);
  let dy = compare(s1.sp.p1.yi, s2.sp.p1.yi); 
  if (dy == 0) {
    dx
  } else {
    dy
  }
};


// input: two horizontal strokes (y-coords of endpoints are equal), each with left endpoint before right one.
//         and with stroke1's left end being further to the left of stroke2 (if their y-coords are equal)
// output: true if they're at the y-level and the x-intervals they define overlap
let overlapH: (stroke, stroke) => bool = (s1, s2) => {
  (s1.sp.p1.yi == s2.sp.p1.yi) && // both strokes at same level
  (s2.sp.p1.xi <= s1.sp.p2.xi)    // second begins at or before first one ends
};

let overlapV: (stroke, stroke) => bool = (s1, s2) => {
  (s1.sp.p1.xi == s2.sp.p1.xi) && // both strokes on same vertical line
  (s2.sp.p1.yi <= s1.sp.p2.yi)    // second begins at or before first one ends
};


// input: two overlapping horizontal strokes at the same y-coord. 
// output: the smallest stroke that contains both

let mergeH: (stroke, stroke) => stroke = (s1, s2) => {
  {...s1,
  sp:{p1: {xi: min(s1.sp.p1.xi, s2.sp.p1.xi), yi: s1.sp.p1.yi},
  p2: {xi: max(s1.sp.p2.xi, s2.sp.p2.xi), yi: s1.sp.p1.yi}},
  }
};

let mergeV: (stroke, stroke) => stroke = (s1, s2) => {
  {...s1,
  sp: {
  p1: {xi: s1.sp.p1.xi, yi: min(s1.sp.p1.xi, s2.sp.p1.yi)},
  p2: {xi: s1.sp.p1.xi, yi: max(s1.sp.p2.xi, s2.sp.p2.yi)}},
  }
};




let showStrokes = (label, strokes, loc, env) => {
  Draw.text(~body=stringOfStrokes(label, strokes), ~pos=loc, env)
}

let rec merge:
  (list<stroke>, (stroke, stroke) => bool, (stroke, stroke) => stroke) => list<stroke> =
  (strokes, overlapTest, mergeR) => {
    switch (strokes) {
    | list{} => strokes
    | list{_a} => strokes
    | list{a, b, ...tl} =>
      if (overlapTest(a, b)) {
        merge(list{mergeR(a, b), ...tl}, overlapTest, mergeR);
      } else {
        list{a, ...merge(list{b, ...tl}, overlapTest, mergeR)};
      }
    };
  };

let clean: (list<stroke>, glEnvT) => list<stroke> =
  (strokes, _env) => {
    //  remove 0-length strokes
    let s1 = List.filter(nonDegenerate, strokes);
    //  split into horiz/vertical
    let sh = List.filter(s => s.sp.p1.yi == s.sp.p2.yi, s1); ///select for equal y-values at endpoints
    let sv = List.filter(s => s.sp.p1.xi == s.sp.p2.xi, s1);
    //    swap ends (as needed) on all horiz strokes so that p1.x < p2.x; similar for vert.
    let sho = List.map(orderX, sh);
    let svo = List.map(orderY, sv);
    //    sort horiz using lexicographic order on x, then y.
    let shSorted = List.sort(compYX, sho);
    let svSorted = List.sort(compXY, svo);
    //    merge horizontal strokes using horizonal overlap; similar for vertical
    let refinedH = merge(shSorted, overlapH, mergeH);
    let refinedV = merge(svSorted, overlapV, mergeV);
    let q = List.append(refinedH, refinedV); // combine the two results
    q;
  };


      
let buildGeom = (s:Types.state) =>
{
  let frameWidth = s.data.width;
  let frameHeight = s.data.depth;
  let dotGap = s.data.spacing;

  let extendedWidth =  dotGap *. ceil(frameWidth /. dotGap);
  let extendedHeight = dotGap *. ceil(frameHeight /. dotGap);
  let ratio = min(float_of_int(displayWidth-2*margin) /. extendedWidth,
                float_of_int(displayHeight-2*margin) /. extendedHeight); // units are pixels/inch

  let dotSpacing = int_of_float(ratio *. dotGap); // units are pixels.

  let wCount = 1 + int_of_float( ceil(frameWidth /. dotGap));
  let hCount = 1 + int_of_float( ceil(frameHeight /. dotGap));

  let frameHeightPixels = int_of_float(floor(ratio *. frameHeight));
  let frameWidthPixels = int_of_float(floor(ratio *. frameWidth));
  {wCount:wCount, hCount:hCount, dotSpacing:dotSpacing, frameHeightPixels: frameHeightPixels, frameWidthPixels: frameWidthPixels}
}

let setup: glEnvT => stateT =
  env => {
    Draw.strokeWeight(lineWidth, env);
//    Env.size(~width=wPixel, ~height=hPixel, env);
    Env.size(~width=displayWidth, ~height=displayHeight, env);
    let d = buildGeom(state); 

    {
      p: Base,
      dragging: false,
      dragStart: {xi:0, yi:0},
      dragNow: {xi:0, yi:0},
      strokeColor: basicStrokeColor,
      strokeList:  makeOuterStrokes(d),
      dots: makeDots(d),
      oldStrokes: list{},
      dg: d,
    }; 
  /// XXX need to copy stroke-list to "ss"
  }; 

let drawFrame = (s, env) => {
  Draw.stroke(frameColor, env);
  Draw.strokeWeight(frameLineWidth, env);
  let h = s.dg.frameHeightPixels; 
  let w = s.dg.frameWidthPixels; 
  let m = margin; 
  let dh = displayHeight; 
  let ll = (m, dh - m); 
  let ur: (int, int) = (w + m, dh - (h + m));
  Draw.line(~p1=ll, ~p2=(m, dh - (h+m)), env); 
  Draw.line(~p1=ll, ~p2=(w+m, dh - m), env);  
  Draw.line(~p1=ur, ~p2=(m, dh - (h+m)), env); 
  Draw.line(~p1=ur, ~p2=(w+m, dh - m), env); 
  Draw.strokeWeight(lineWidth, env);
};

let drawGrid: (stateT, glEnvT) => unit =
  (s, e) => {
    Draw.fill(dotColor, e);

    Draw.noStroke(e);
    ignore(
      List.map(
        p =>
          Draw.ellipsef(~center=gToW(s, p), ~radx=dotRadius, ~rady=dotRadius, e),
        s.dots,
      ),
    ); 
    ();
  }; 

let drawStrokes = (state, env) => {
  Draw.noFill(env);
  Draw.stroke(basicStrokeColor, env);
   
  // largest x- and y-values to draw for any stroke.
  let x0 = float_of_int(state.dg.frameWidthPixels + margin);
  let y0 = float_of_int(displayHeight - (state.dg.frameHeightPixels + margin));
 
  if (randomStrokeColors) {
    ignore(
      List.map(
        s => {
          Draw.stroke(s.color, env);
          let (x1, y1) = gToW(state, s.sp.p1);
          let p1 = (min(x1, x0), max(y1, y0));
          let (x2, y2) = gToW(state, s.sp.p2);
          let p2 = (min(x2, x0), max(y2, y0));
          Draw.linef(~p1=p1, ~p2=p2, env); 
        },
        state.strokeList, 
      ),
    ); 
  } else {
    ignore(List.map(s => {
      let (x1, y1) = gToW(state, s.sp.p1);
          let p1 = (min(x1, x0), max(y1, y0));
          let (x2, y2) = gToW(state, s.sp.p2);
          let p2 = (min(x2, x0), max(y2, y0));
          Draw.linef(~p1=p1, ~p2=p2, env); 
    }, 
    state.strokeList));
  };
  if (true) {
    showStrokes("Old", state.oldStrokes, (380,20), env);
    showStrokes("New", state.strokeList, (640, 20), env);
  }
 
}; 

let drawCurrentLine: (stateT, glEnvT) => unit =
  (state, env) =>
    if (state.dragging == false) { 
      ();
    } else {
      Draw.noFill(env);
      Draw.stroke(dragLineColor, env);
      Draw.linef(~p1=gToW(state, state.dragStart), ~p2=gToW(state, state.dragNow), env);
    };

/* generate a point near "current" that's either vertically or horizontally aligned 
** with dragStart, based on whether "current" is more v or h-aligned. 
*/
let align: (gpoint, gpoint) => gpoint = ({xi:x0, yi:y0}, {xi:x1, yi:y1}) => 
{
  let adx = abs(x0 - x1);
  let ady = abs(y0 - y1);
  if (adx < ady){
    {xi: x0, yi: y1}
  } else {
    {xi: x1, yi: y0}
  };
}

// input: a grid point (i,j)
//        a stroke from p1 to p2
// output: true if the point (i,j) lies on the segment between p1 and p2 (inclusive)
let strokeContains: (gpoint, stroke) => bool = ( {xi: i, yi: j}, s) => 
{
  let {xi: x1, yi: y1} = s.sp.p1;
  let {xi: x2, yi: y2} = s.sp.p2; 

  switch( (x1 == x2), (y1 == y2)) {
    | (true, true) => (x1 == i) && (y1 == j)
    | (true, false) => (x1 == i) && (((y1-j)*(y2-j)) <= 0)
    | (false, true) => (y1 == j) && (((x1-i)*(x2-i)) <= 0)
    | (false, false) => false  
    };
} 

// input: a mouse-click location (x, y)
//        a list of strokes
//        a limit, where any stroke whose distance is greater than this limit is ignored
// Output: option: among all strokes containing the grid-point gp associated to (x,y), some one
//        closest to x,y (or None, if no stroke contains gp, of if the stroke-distance is greater than 'limit')
let findNearest:(stateT, (int, int), list<stroke>, float) => option<stroke> = (s, (x,y), strokes, limit) =>  
{
  let gp = wToG(s, (float_of_int(x), float_of_int(y))); // nearest grid point

  let xgf = float_of_int(x - margin)/. float_of_int(s.dg.dotSpacing);
  let ygf = (float_of_int((displayHeight - y) - margin))/. float_of_int(s.dg.dotSpacing);

  let dd = (x, y, s) => {
    let {xi: x1, yi: y1} = s.sp.p1;
    let {xi: x2, yi: _y2} = s.sp.p2; 
  if (x1 == x2) { abs_float(x -. float_of_int(x1)) } else { abs_float(y -. float_of_int(y1))};
  }

  let rec best = sAndDList  => 
  {
    switch(sAndDList) {
      | list{} => None
      | list{(s,d)} => Some((s, d))
      | list{q1, q2, ... tl} => {
        let Some((rStroke, rDist)) = best(list{q2, ... tl});
        let (_, hDist) = q1; 
        if (hDist <= rDist) { Some(q1) } else { Some((rStroke, rDist))};
      }
    }
  }

  let containingStrokes = List.filter(s => strokeContains(gp, s), strokes);
  let sAndD = List.map(s => (s, dd(xgf, ygf, s)), containingStrokes);
  let limitedSAndD = List.filter ( ((_s,d)) => (d <= limit), sAndD);
  // for each, compute distance to (xgf, ygf)
  switch(best(limitedSAndD)) {
    | None => None
    | Some((s, _f)) => Some(s)
  };
};

let updateState = (state, env) => {
  let press = Env.mousePressed(env);
  let release = state.dragging && (!press);

  let shift = Env.key(LeftShift, env) || Env.key(RightShift, env);
  let mouse = Env.mousePressed(env);

  let (x, y) = Env.mouse(env);
  let loc = wToG(state, (float_of_int(x), float_of_int(y)));
  
  let s = state.p;
  let newPhase = switch (s, shift, mouse) {
  | (Base, true, true) => DelStart
  | (Base, true, false) => Shift
  | (Base, false, true) => Dragging
  | (Base, false, false) => Base
  | (Shift, true, true) => DelStart
  | (Shift, true, false) => Shift
  | (Shift, false, true) => Dragging
  | (Shift, false, false) => Base
  | (DelStart, _, _) => DelDone
  | (DelDone, true, true) => DelDone
  | (DelDone, true, false) => Shift
  | (DelDone, false, true) => Neutral
  | (DelDone, false, false) => Base
  | (Neutral, true, true) => DelDone
  | (Neutral, true, false) => Shift
  | (Neutral, false, true) => Neutral
  | (Neutral, false, false) => Base
  | (Dragging, true, true) => Dragging
  | (Dragging, true, false) => Shift  // process end of dragging
  | (Dragging, false, true) => Dragging
  | (Dragging, false, false) => Base  // process end of dragging
  };

  let newDragStart = if (state.p == Base && newPhase==Dragging) {loc} else {state.dragStart};
  let newDragNow = if (state.p == Dragging && newPhase==Dragging) {align(state.dragStart, loc)} else {state.dragStart};
  let newStrokeList =
    if (state.p == Dragging && newPhase != Dragging) {
      clean(list{
        {sp: {p1: state.dragStart, p2: align(state.dragStart, loc)}, color: rColor()},
        ...state.strokeList,
      }, env);
    } else {
      if (state.p == DelStart && newPhase == DelDone) {
        let closest = findNearest(state, (x, y), state.strokeList, 0.5);
        switch(closest) {
          | None => state.strokeList
          | Some(q) => List.filter(s => ((s.sp.p1 != q.sp.p1) || (s.sp.p2 != q.sp.p2)), state.strokeList)
        } 
     } else {
       state.strokeList
     }
    };

  // If the new list is different from the old one, update the mutable record
  // that lets us share that with the rest of the world. 
  dataCarrier.strokes = if (newStrokeList != state.strokeList) { 
    newStrokeList 
    } else {
      dataCarrier.strokes
      };

  {
    ...state,
    p : newPhase,
    dragging:
      if (press) {
        true;
      } else if (release) {
        false;
      } else {
        state.dragging;
      },
    dragStart: newDragStart,
    dragNow: newDragNow,
    oldStrokes: (newStrokeList != state.strokeList)? state.strokeList : state.oldStrokes,
    strokeList: (newStrokeList != state.strokeList)? {dataCarrier.strokes = newStrokeList; newStrokeList} : state.strokeList,
  };
};
  
let draw = (state, env) => {
  Draw.background(bgColor, env);
  drawGrid(state, env);
  drawFrame(state, env);
  drawStrokes(state, env);
  drawCurrentLine(state, env);
  updateState(state, env)
}


//run(~setup, ~draw, ());
//==============================================================================================

  React.useEffect(() => {
    setScreenId(id)
    run(~setup, ~draw, ())
    None
  })
  <canvas id />
}