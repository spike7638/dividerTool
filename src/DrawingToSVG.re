open Types;

// Local types
type f = float; 
type direction = H | V;
type meeting = Cross | Terminate | End; // does a crossing span meet the main span by Crossing it, or by terminating at it? 
                                        // or is this a "virtual" meeting at one of the two ends of the span? (an End) 
type spanSummary = {m:meeting, pos:int}



/* 
** inputs: 
**    w: width of divider assembly overall
**    g: grid spacing
**    t: material thickness
** output:
**    c: a function taking a grid coordinate n and producing a corresponding world coordinate
**       so that c(0) = 0; with c(k) = kg in general, except that if n >= (w-t)/g, then c(n) = (w-t);
*/
let converterProducer: (float, float, float, int) => float =
  (w, g, t, n) =>
    if (float_of_int(n) >= (w -. t) /. g) {
      w -. t;
    } else {
      float_of_int(n) *. g;
    };


let classifyH: (int, list(span)) => list(spanSummary) =
  (y, spans) => List.map(s => {m:(s.p1.yi == y || s.p2.yi == y) ? Terminate:Cross, pos:s.p1.xi}, spans);

let rec convertHelper:(float, int, int, int, list(spanSummary), int=>float) => list(feature) = (thickness, ss, sf, n, meets, gToWH) => {
let t = thickness; 
switch (meets) {
| [] => failwith("Empty meets-list in convertHelper!")
| [{m: q, pos: k}] =>
  if (k != n) {
    failwith("Bad position in spanSummary!");
  } else {
    switch (q) {
    | End => [G(gToWH(sf) +. t -. gToWH(n))]
    | Cross =>
      if (sf != n) {
        [XL(t), G(gToWH(sf) -. gToWH(n))];
      } else {
        [T(t)];
      }
    | Terminate =>
      if (sf != n) {
        [S(t), G(gToWH(sf) -. gToWH(n))];
      } else {
        [CL(t)];
      }
    };
  }
| [{m: q, pos: k}, {m: r, pos: l}, ...tl] =>
  if (k != n) {
    failwith("Bad position in spanSummary!");
  } else {
    let fill = G(gToWH(l) -. gToWH(k));
    let fillShort = G(gToWH(l) -. (gToWH(k) +. t));

    switch (q) {
    | End => [fill, ...convertHelper(thickness, ss, sf, l, [{m: r, pos: l}, ...tl], gToWH)]
    | Cross => if (k != ss){
        [
        XL(t),
        fillShort,
        ...convertHelper(thickness, ss, sf, l, [{m: r, pos: l}, ...tl], gToWH),
      ]
    } else {
        [
        T(t),
        fillShort,
        ...convertHelper(thickness, ss, sf, l, [{m: r, pos: l}, ...tl], gToWH),
      ]
    }
    | Terminate =>
      if (k == ss) {
        [
          CL(t),
          fillShort,
          ...convertHelper(thickness, ss, sf, l, [{m: r, pos: l}, ...tl], gToWH),
        ];
      } else {
        [
          S(t),
          fillShort,
          ...convertHelper(thickness, ss, sf, l, [{m: r, pos: l}, ...tl], gToWH),
        ];
      }
    };
  }
};

}

let enhance: (span, list(spanSummary)) => list(spanSummary) = (s, flist) => 
{
    switch(flist) {
        | [] => [{m:End, pos: s.p1.xi}, {m:End, pos: s.p2.xi}]
        | [head, ... _tail] => {
            let nFeature = List.length(flist);
            let lastFeature = List.nth(flist, nFeature-1);
            let fixedLast = if (lastFeature.pos != s.p2.xi) {flist @ [{m:End, pos:s.p2.xi}]} else {flist};
            if (head.pos != s.p1.xi) [{m:End, pos: s.p1.xi}, ... fixedLast] else {fixedLast}
        }
    } 
}

let rec cleanup:list(feature) => list(feature) = ss => {
    switch(ss){
        | [] => []
        | [q] => [q]
        | [G(a), G(b), ...tail] => cleanup([G(a +. b), ...tail])
        | [hd, ...tl] => [hd, ...cleanup(tl)]
    }
};

let convertOne: (span, list(span), settings) => list(feature) = (s, spans, settings) => {
    let span1 = classifyH(s.p1.yi, spans);
    let spanSummaries = enhance(s, span1);
    let gToWH = converterProducer(settings.width, settings.spacing, settings.thickness);

    cleanup(convertHelper(settings.thickness, s.p1.xi, s.p2.xi, s.p1.xi, spanSummaries, gToWH));
}  

let swap:span => span = s => {p1:s.p2, p2:s.p1};
let isHorizontal:span => bool = s => (s.p1.yi == s.p2.yi);
// test whether a vertical span v meets a horizontal span h

let meets: (span, span) => bool = (h, v) => 
  (h.p1.yi >= v.p1.yi) &&
  (h.p1.yi <= v.p2.yi) &&
  (h.p1.xi <= v.p1.xi) &&
  (h.p2.xi >= v.p1.xi);

// make sure all horizontal spans have p1 left of p2; all vert spans have p1 below p2
let polish: span => span = s => {
    if (isHorizontal(s)) {
        (s.p1.xi < s.p2.xi)? s : swap(s); 
    } else {
        (s.p1.yi < s.p2.yi)? s : swap(s); 
    } 
};

let flipPoint:gpoint => gpoint = p => {xi: p.yi, yi:p.xi};
let flipSpan:span => span = s => polish({p1: flipPoint(s.p1), p2: flipPoint(s.p2)});
let flipSpanList: list(span) => list(span) =  s => List.map(flipSpan, s)
let flipFeature: feature => feature = q => {
    switch(q) {
        | G(_) 
        | S(_) 
        | D(_)
        | T(_) => q
        | XU(f) => XL(f)
        | XL(f) => XU(f) 
        | CU(f) => CL(f) 
        | CL(f) => CU(f)
    }
}
let flipFeatureList = x => List.map(flipFeature, x);
let flipFeatureListList = x => List.map(flipFeatureList, x);
  
// for each span hs in hSpans
//    find all vSpans that meet it
//    sort them left to right
//    apply "convert(hs, this-sorted-list)"
//    and accumulate < use list.foldRight((x, y) => [x, ...r], result-of-appn, []) >
let prepAndConvert: (list(span), list(span), settings) => list(list(feature)) = (hSpans, vSpans, settings) => {
    let qq: span => list(feature)=  s => 
    {
        let crosses = List.filter(v => meets(s, v), vSpans)
        let cross2 = List.sort((s1, s2) => compare(s1.p1.xi, s2.p1.xi), crosses)
        convertOne(s, cross2, settings)
    }
    List.fold_right((x, r) => [qq(x), ... r], hSpans, []);
}
// convertAll: do cleanup; sort into H and V; for each H apply convertOne; for each V apply the analogous thing. 
let convertAll: (list(span), settings) => list(list(feature)) = (drawing, settings) => {
    let d = List.map(polish, drawing); //make sure spans are in increasing order
    let dH = List.filter(isHorizontal, d);
    let dV = List.filter(x => !isHorizontal(x), d);

    let fH = prepAndConvert(dH, dV, settings);
    let fV = flipFeatureListList(prepAndConvert(flipSpanList(dV), flipSpanList(dH), settings));
    fH @ fV
}
let convertAll2: (list(span), settings) => (list(list(feature)), list(list(feature))) = (drawing, s) => {
    let d = List.map(polish, drawing); //make sure spans are in increasing order
    let dH = List.filter(isHorizontal, d);
    let dV = List.filter(x => !isHorizontal(x), d);

    let fH = prepAndConvert(dH, dV, s);
    let fV = flipFeatureListList(prepAndConvert(flipSpanList(dV), flipSpanList(dH), s));
    (fH, fV)
}



// Testing code

// let mainSpan = {p1:{xi:1, yi:3}, p2:{xi:8, yi:3}};
// let cross1 = {p1:{xi:1, yi:3}, p2:{xi:1, yi:5}}; //corner at start
// let cross1t = {p1:{xi:1, yi:1}, p2:{xi:1, yi:5}}; //tee at start
// let cross2 = {p1:{xi:3, yi:1}, p2:{xi:3, yi:5}}; //solid X crossing
// let cross3 = {p1:{xi:5, yi:3}, p2:{xi:5, yi:5}}; //tee in middle
// let cross4 = {p1:{xi:8, yi:3}, p2:{xi:8, yi:5}}; //corner at end 
// let cross4t = {p1:{xi:8, yi:1}, p2:{xi:5, yi:5}}; //tee at end
// let testCXTT = [cross1, cross2, cross3, cross4];
// let testOXTT = [cross2, cross3, cross4];
// let testOXTO = [cross2, cross3];
// let testTXST = [cross1t, cross2, cross3, cross4t];

let soi = string_of_int;
let sof = Js.Float.toString;
let string_of_feature: feature => string = q => 
switch(q){
    | G(f) => "G(" ++ sof(f) ++ ")"
    | S(f) => "S(" ++ sof(f) ++ ")"
    | T(f) => "T(" ++ sof(f) ++ ")"
    | XU(f) => "XU(" ++ sof(f) ++ ")"
    | XL(f) => "XL(" ++ sof(f) ++ ")"
    | CU(f) => "CU(" ++ sof(f) ++ ")"
    | CL(f) => "CL(" ++ sof(f) ++ ")"
    | D(f) => "D(" ++ sof(f) ++ ")"
};
//type feature = G(f) | S(f) | T(f) | XU(f) | XL(f) | CU(f) | CL(f);
//type direction = H | V;
let string_of_direction: direction => string = q => 
switch(q){
    | H => "H"
    | V => "V"
    };
let string_of_meeting: meeting => string = q => 
switch(q){
    | Cross => "Cross"
    | Terminate => "Term"
    | End => "End"
    };
let string_of_span_summaryi: spanSummary => string = ({m:meet, pos:n}) => 
"ss: " ++ string_of_meeting(meet) ++ ", " ++ soi(n)

// print_string(sof(gToWH(0)) ++ "?= 0\n");
// print_string(sof(gToWH(0)) ++ "?= 0\n");
// print_string(sof(gToWH(7)) ++ "?= 210\n");
// print_string(sof(gToWH(8)) ++ "?= 215\n");
// // let frameWidth = 220.0; 
// // let gridSpacing = 30.0;
// // let thickness = 5.0;
// // let t = thickness;
// // let gToWH = converterProducer(frameWidth, gridSpacing, thickness);
// // let classifyH: (int, list(span)) => list(spanSummary) =
// let res1 = classifyH(3, testCXTT);
// List.map(x=> print_string(string_of_span_summary(x)++ "\n"), res1); 
// print_string("T at x = 1, XU at x = 3, S at x = 5, T at x = 8\n");
// let res1e = enhance(mainSpan, res1);
//  print_string("T at x = 1, XU at x = 3, S at x = 5, T at x = 8\n");

// print_string("  MISSING LEFT END\n")
// let res11 = classifyH(3, testOXTT);
// List.map(x=> print_string(string_of_span_summary(x)++ "\n"), res11); 
// print_string("XU at x = 3, S at x = 5, T at x = 8\n");
// let res11e = enhance(mainSpan, res11);
// List.map(x=> print_string(string_of_span_summary(x)++ "\n"), res11e); 
// print_string("E at x = 1, XU at x = 3, S at x = 5, T at x = 8\n");
// print_string("\n\n  MISSING BOTH ENDS\n")
// let res11 = classifyH(3, testOXTO);
// List.map(x=> print_string(string_of_span_summary(x)++ "\n"), res11); 
// print_string("XU at x = 3, S at x = 5\n");
// let res11e = enhance(mainSpan, res11);
// List.map(x=> print_string(string_of_span_summary(x)++ "\n"), res11e); 
// print_string("E at x = 1, XU at x = 3, S at x = 5, E at x = 8\n");
// //type meeting = Cross | Terminate | End; // does a crossing span meet the main span by Crossing it, or by terminating at it? 
//     // or is this a "virtual" meeting at one of the two ends of the span? 
// //type spanSummary = {m:meeting, pos:int}
// // let rec convertHelper:(int, int, int, list(spanSummary)) => list(feature) = (ss, sf, n, meets) => {
// // let enhance: (span, list(spanSummary)) => list(spanSummary) = (s, flist) => 
// // let convertOne: (span, list(span)) => list(feature) = (s, spans) => {
// print_string("=======================\n")
// let res2 = convertOne(mainSpan, testCXTT);
// List.map(x=> print_string(string_of_feature(x)++ " "), res2); print_string("\n");
// print_string("  CU(5), G(55), XU(5), G(55), S(5), G(60), CU(5)\n")
// let res3 = convertOne(mainSpan, testOXTT);
// List.map(x=> print_string(string_of_feature(x)++ " "), res3);  print_string("\n");
// print_string("  G(60), XU(5), G(55), S(5), G(60), CU(5)\n")
// let res4 = convertOne(mainSpan, testOXTO);
// List.map(x=> print_string(string_of_feature(x)++ " "), res4);  print_string("\n");
// print_string("  G(60), XU(5), G(55), S(5), G(65)\n")
// print_string("=======================\n")
// print_string("no crossings\n")
// let res5 = convertOne(mainSpan, []);
// List.map(x=> print_string(string_of_feature(x)++ " "), res5);  print_string("\n");
// print_string("  G(190)\n");
// print_string("=======================\n");
// print_string("One crossing\n");
// let res6 = convertOne(mainSpan, [cross2]); // an "X"
// List.map(x=> print_string(string_of_feature(x)++ " "), res6);  print_string("\n");
// print_string("  G(60), XU(5), G(125)\n")

// print_string("=======================\n")
// print_string("=======================\n")
// let res7 = convertOne(mainSpan, testTXST);
// List.map(x=> print_string(string_of_feature(x)++ " "), res7); print_string("\n");
// print_string("  T(5), G(55), XU(5), G(55), S(5), G(60), T(5)\n")



// let h1 = {p1:{xi:1, yi:1}, p2:{xi:3, yi:1}};
// let h2 = {p1:{xi:1, yi:2}, p2:{xi:3, yi:2}};
// let h3 = {p1:{xi:2, yi:3}, p2:{xi:3, yi:3}};
// let h4 = {p1:{xi:1, yi:4}, p2:{xi:2, yi:4}};
// let v1 = {p1:{xi:1, yi:1}, p2:{xi:1, yi:4}};
// let v2 = {p1:{xi:2, yi:1}, p2:{xi:2, yi:4}};
// let v3 = {p1:{xi:3, yi:1}, p2:{xi:3, yi:2}};

// let drawing = [h1, h2, h3, h4, v1, v2, v3];
// let q = convertAll(drawing);

// let printInstructions =  b =>
// {
//     List.map(x => print_string(string_of_feature(x)++ " "), b) |> ignore;
//     print_string("\n================\n");
// } 
// List.map( printInstructions, q); 


let spanList_of_strokeList: list(stroke) => list(span) = sl => 
List.map( s => s.sp, sl);

let converter: (list(stroke), settings) => list(list(feature)) = (sl, settings) =>
convertAll(spanList_of_strokeList(sl), settings);

let stringOfStrokeList:  (list(stroke), settings) => string = (sl, settings) => {
  let c:list(list(feature)) = converter(sl, settings);
  let make_string = sl => {
    List.fold_right( (x, s)=> (string_of_feature(x)++ ", ") ++ s, sl, "")  
  }
  let d = List.fold_right( (x, s) => (make_string(x) ++ "\n" ++ s), c, "") 
  d
} 

// type point = (float, float); // point for SVG stuff
// type boxSpec = {
//   height: float,
//   width: float,
//   lowerLeft: point,
//   isDip: bool /* disgusting hack; really should have "boxes" and "dips" and possibly "lineSegment"s too*/
// };

// type panelGeom = list(feature); 

// type panel = {
//   geom: panelGeom,
//   name: string,
// }; /* horiz panels never contains CUs or XUs; vert panels never contain CLs or XLs */

// type divider = {
//   horiz: list(panel), /* horiz panels never contains CUs or XUs */
//   vert: list(panel), /* vert panels never contain CLs or XLs   */
//   spec: specs,
// };

// type span = {p1:gpoint, p2:gpoint};

 
// type drawing = list(stroke);

// type specs = {
//   height: float,
//   dipSize: float,
//   t: float,
//   pinCount: int, /* for one pin, divide height into 3 parts; for 3 tabs, divide into 5 */
//   tabFraction: float /*  between 0 and 1 */
// };
// type settings = {
//   counter: int, // add more later
//   thickness: float,
//   width: float,
//   depth: float,
//   height: float,
//   spacing: float,
//   includeEnclosure: bool,
//   dipPercentageH: float,
//   dipPercentageV: float,
//  }
 
// type state = {
//   data: settings,
//   svg: string,
//   drawing: list<stroke>,
// }

// type panelGeom = list(feature); 

// type panel = {
//   isHorizontal: bool,
//   geom: panelGeom,
//   name: string, 
// }; /* horiz panels never contains CUs or XUs; vert panels never contain CLs or XLs */

// type divider = {
//   horiz: list(panel), /* horiz panels never contains CUs or XUs */
//   vert: list(panel), /* vert panels never contain CLs or XLs   */
//   spec: specs,
// };

let stringOfFeatureList = fl => 
     List.fold_right((x,s) => (string_of_feature(x)++ " ") ++ s, fl, "");

let dividerToString: divider => string = d => {
let s1 = "specs: skipped\n";
let s2 = "\nHoriz:\n";
let psMap = (p, s) => (p.name ++ ((p.isHorizontal)?" H ": " V ") ++ stringOfFeatureList(p.geom)) ++ s;
let s3 = List.fold_right (psMap, d.horiz, "");
let s4 = "\nVert:\n";
let s5 = List.fold_right(psMap, d.vert, "");
//s1 ++ s2 ++ s4 ++ "\n"
s1 ++ s2 ++ s3 ++ s4 ++ s5 ++ "\n"
}  

let drawingToDivider: (Types.state, drawing) => divider = (st, drawing) => {
  let settings = st.data;
  let t = settings.thickness;
  // convert drawing to list of spans
  let d1 = spanList_of_strokeList(drawing);
  // split spans into horizontal and vertical
  let dH = List.filter(isHorizontal, d1);
  let dV = List.filter(x => !isHorizontal(x), d1);
  // build "specs" structure
  let sp0:specs = {height: settings.height,
     dipSizeH: settings.height *. settings.dipPercentageH /. 100.0,
     dipSizeV: settings.height *. settings.dipPercentageV /. 100.0,
     t: settings.thickness,
     pinCount: 5, /* for one pin, divide height into 3 parts; for 3 tabs, divide into 5 */
     tabFraction: 0.3, //float /*  between 0 and 1 */
     };
  let (dH, dV) = convertAll2(d1, st.data);
  // convert each horizontal span's feature-list into a panel to get "horiz" component of divider
  let horiz0 = List.mapi( (i, fl) => {geom:fl, isHorizontal: true, name:"H"++string_of_int(i)}, dH);
  let vert0 = List.mapi( (i, fl) => {geom:fl, isHorizontal: false, name:"V"++string_of_int(i)}, dV);
  // assemble horiz, vert, and specs into a return value. 
  let result = {horiz:horiz0, vert:vert0, spec:sp0};  
  let ds = dividerToString(result);
  Js.log(ds);
  //if (true) {Js.log(ds)} else {};
  result; 
} 

    

//============OLD CODE ====//

let sof = Js.Float.toString;
let rec checkPanelhelper: panelGeom => bool =
  lst =>
    switch (lst) {
    | [] => true
    | [CU(_), ..._] => false
    | [CL(_), ..._] => false
    | [_, ...tl] => checkPanelhelper(tl)
    };

/* should also check Gs at ends */
let checkPanel: panelGeom => bool =
  lst =>
    switch (lst) {
    | []
    | [_] => false
    | [G(_), ..._] => false
    | lst =>
      switch (List.rev(lst)) {
      | [G(_), ..._] => false
      | _ => checkPanelhelper(lst)
      }
    };

let rec panelLength: panelGeom => float =
  fun
  | [] => 0.0
  | [CU(f), ...rst] => f +. panelLength(rst)
  | [CL(f), ...rst] => f +. panelLength(rst)
  | [XU(f), ...rst] => f +. panelLength(rst)
  | [XL(f), ...rst] => f +. panelLength(rst)
  | [S(f), ...rst] => f +. panelLength(rst)
  | [T(f), ...rst] => f +. panelLength(rst)
  | [G(f), ...rst] => f +. panelLength(rst)
  | [D(f), ...rst] => f +. panelLength(rst);

/*
  inputs:
    start: how many times pinHeight at which to start bottom-most cut-out
    fin: same, but for top cut-out
    ht: the height of each pin (or cutout)
    wid: the horizontal extent of each pin (usually spec.t)
    x: the x-coor of the lower left corner
 */
let rec pinHelper: (int, int, float, float, float) => list(boxSpec) =
  (start, fin, ht, wid, x) =>
    if (start > fin) {
      [];
    } else {
      let s = float_of_int(start);
      [
        {lowerLeft: (x, s *. ht), height: ht, width: wid, isDip: false},
        ...pinHelper(start + 2, fin, ht, wid, x),
      ];
    };

let pinU: (float, feature, specs) => list(boxSpec) =
  (x, c, s) =>
    switch (c) {
    | CL(f) =>
      let pinHeight = s.height /. float_of_int(2 * s.pinCount + 1);
      pinHelper(0, 2 * s.pinCount, pinHeight, f, x);
    | _ => failwith("Bad upper-pin specification")
    };

let pinL: (float, feature, specs) => list(boxSpec) =
  (x, c, s) =>
    switch (c) {
    | CU(f) =>
      let pinHeight = s.height /. float_of_int(2 * s.pinCount + 1);
      pinHelper(1, 2 * s.pinCount - 1, pinHeight, f, x);
    | _ => failwith("Bad lower-pin specification")
    };

let outerBox: (panelGeom, specs) => boxSpec =
  (lst, spec) => {
    height: spec.height,
    width: panelLength(lst),
    lowerLeft: (0.0, 0.0),
    isDip: false,
  };

/* inputs;
   x: location of left side of tab
   c: the tab specification
   s: the overall box specification.
   output:
   a list containing the two boxSpecs for the boxes that need to be removed.
   */

let tabBoxes: (float, feature, specs) => list(boxSpec) =
  (x, c, s) =>
    switch (c) {
    | T(f) =>
      let q = (1.0 -. s.tabFraction) /. 2.0;
      let yBot = q *. s.height;
      let yTop = (1.0 -. q) *. s.height;
      [
        {height: yBot, width: f, lowerLeft: (x, 0.0), isDip: false},
        {height: yBot, width: f, lowerLeft: (x, yTop), isDip: false},
      ];
    | _ => failwith("Bad tab specification")
    };
let tabSlots: (float, feature, specs) => list(boxSpec) =
  (x, c, s) =>
    switch (c) {
    | S(f) =>
      let q = (1.0 -. s.tabFraction) /. 2.0;
      let yBot = q *. s.height;
      let yTop = (1.0 -. q) *. s.height;
      [
        {height: yTop -. yBot, width: f, lowerLeft: (x, yBot), isDip: false},
      ];
    | _ => failwith("Bad slot specification")
    };

let slitL: (float, feature, specs) => list(boxSpec) =
  (x, c, s) =>
    switch (c) {
    | XU(f) =>
      let slotHeight = 0.5 *. s.height;
      [
        {
          height: slotHeight,
          width: f,
          lowerLeft: (x, slotHeight),
          isDip: false,
        },
      ];
    | _ => failwith("Bad lower-slit specification")
    };

let slitU: (float, feature, specs) => list(boxSpec) =
  (x, c, s) =>
    switch (c) {
    | XL(f) =>
      let slotHeight = 0.5 *. s.height;
      [{height: slotHeight, width: f, lowerLeft: (x, 0.0), isDip: false}];
    | _ => failwith("Bad upper-slit specification")
    };


let stringOfBox: boxSpec => string =
  bs => {
    let h = bs.height;
    let w = bs.width;
    let (x, y) = bs.lowerLeft;
    "(" ++ sof(x) ++ ", " ++ sof(y) ++ "); w = " ++ sof(w) ++ ", h = " ++ sof(h) ++ "\n";
  };
  
/*
 ** at location x, start a "dip" of depth "dipSize", starting at
 ** x + dipSize, and ending at x + f - dipSize, if there's room; if not, return an empty list of "boxes"
 */
let dipGap: (float, float, float, float) => list(boxSpec) =
  (x, f, height, dipSize) => {
    let xs = x +. dipSize;
    let xf = x +. f -. dipSize;
    let xs = x +. 0.25;
    let xf = x +. f -. 0.25;
    let w = xf -. xs;
    let q = min(0.375, dipSize)
    if (w < 4.0 *. q) {
      []; // simply draw no dip! (formerly: failwith("Impossible dip length!");)
    } else {
      [
        {
          height: height,
          width: xf -. xs,
          lowerLeft: (xs, height -. dipSize),
          isDip: true,
        },
      ];
    };
  };

let rec allBoxesHelper: (panelGeom, specs, float, bool) => list(boxSpec) =
  (panel, sp, x, isHorizontal) =>
    switch (panel) {
    | [] => []
    | [CU(f), ...rst] => pinL(x, CU(f), sp) @ allBoxesHelper(rst, sp, x +. f, isHorizontal)
    | [CL(f), ...rst] => pinU(x, CL(f), sp) @ allBoxesHelper(rst, sp, x +. f, isHorizontal)
    | [XU(f), ...rst] =>
      slitL(x, XU(f), sp) @ allBoxesHelper(rst, sp, x +. f, isHorizontal)
    | [XL(f), ...rst] =>
      slitU(x, XL(f), sp) @ allBoxesHelper(rst, sp, x +. f, isHorizontal)
    | [S(f), ...rst] =>
      tabSlots(x, S(f), sp) @ allBoxesHelper(rst, sp, x +. f, isHorizontal)
    | [T(f), ...rst] =>
      tabBoxes(x, T(f), sp) @ allBoxesHelper(rst, sp, x +. f, isHorizontal)
    | [G(f), ...rst] =>       dipGap(x, f, sp.height, isHorizontal? sp.dipSizeH:sp.dipSizeV) @ allBoxesHelper(rst, sp, x +. f, isHorizontal)
//allBoxesHelper(rst, sp, x +. f, isHorizontal)
    | [D(f), ...rst] =>
      //      print_string("making a dip!");
      dipGap(x, f, sp.height, isHorizontal? sp.dipSizeH:sp.dipSizeV) @ allBoxesHelper(rst, sp, x +. f, isHorizontal)
    };

let allBoxes: (panelGeom, specs, bool) => list(boxSpec) =
  (panel, sp, isHorizontal) => [outerBox(panel, sp), ...allBoxesHelper(panel, sp, 0.0, isHorizontal)];

let textOfPoint: (float, float) => string =
  (x, y) => sof(72.0 *. x) ++ ", " ++ sof(72.0 *. y) ++ " ";

let ps = (name, x, y) =>
  print_string(name ++ ": " ++ sof(x) ++ ", " ++ sof(y) ++ "\n");

let boxToPathD: (boxSpec, specs, float) => string =
{
  (bs, sp, dipSize) => {
    let helper = (xs, ys, xq, yq, xm, ym, xt, yt, xf, yf) => {
      "M "
      ++ textOfPoint(xs, ys)
      ++ "Q "
      ++ textOfPoint(xq, yq)
      ++ "  "
      ++ textOfPoint(xm, ym)
      ++ "T "
      ++ textOfPoint(xt, yt)
     // ++ "M "
     // ++ textOfPoint(xf, yf);
    };

    if (bs.isDip) {
      let d = dipSize;
      let q = min(d, 0.375); // radius to use for dip-bend
      let ((xs, _), ys) = (bs.lowerLeft, bs.height);
      let (xq, yq) = (xs +. q, ys);
      let (xm, ym) = (xs +. q, ys -. d /. 2.0);
      let (xt, yt) = (xs +. 2. *. q, ys -. d);
      let (xf, yf) = (xs +. 2. *. q, ys -. d);
      let st1 = helper(xs, ys, xq, yq, xm, ym, xt, yt, xf, yf) ++ " ";

      let (xs2, ys2) = (fst(bs.lowerLeft) +. bs.width, bs.height);
      let (xq2, yq2) = (xs2 -. q, ys2);
      let (xm2, ym2) = (xs2 -. q, ys2 -. d /. 2.0);
      let (xt2, yt2) = (xs2 -. 2. *. q, ys2 -. d);
      let (xf2, yf2) = (xs2 -. 2. *. q, ys2 -. d);

      let st2 = "M " ++ textOfPoint(xf, yf) ++ "L " ++ textOfPoint(xf2, yf2);
      let st3 =
        helper(xs2, ys2, xq2, yq2, xm2, ym2, xt2, yt2, xf2, yf2) ++ " ";
 
      st1 ++  st2 ++ st3;
      // <path d="M200,300 Q375,300 400,400 T600,500 M 600,500 L 800,500"
    } else {
      let hs = sof(72.0 *. bs.height);
      let ws = sof(72.0 *. bs.width);
      let (x, y) = bs.lowerLeft;
      let (xs, ys) = (sof(72.0 *. x), sof(72.0 *. y));
      "M "
      ++ xs
      ++ ", "
      ++ ys
      ++ "  v "
      ++ hs
      ++ "  h "
      ++ ws
      ++ "  v -"
      ++ hs
      ++ "  z\n";
    };
  };
}

let rec boxListToPathD: (list(boxSpec), specs, float) => string =
  (bsl, sp, dipSize) => {
    //print_string("length: " ++ string_of_int(List.length(bsl)) ++ "\n");
    switch (bsl) {
    | [] => ""
    | [b, ...tail] => boxToPathD(b, sp, dipSize) ++ boxListToPathD(tail, sp, dipSize)
    };
  };

let boxListToPath: (list(boxSpec), specs, float) => string =
  (bList, sp, dipSize) => {
    let dSpec = "d=\" \n" ++ boxListToPathD(bList, sp, dipSize) ++ "\"";
    let head = "<path id=\"\" vector-effect=\"non-scaling-stroke\" class=\"st0\" ";
    let tail = "/>\n";
    head ++ dSpec ++ tail;
  };
 
let text= (x:float, y:float, s:string) => 
"\n<text x=\"" ++ Js.Float.toString(x) ++ 
   "\" y=\"" ++ Js.Float.toString(y)  ++"\" fill=\"#00FF00\" >" ++ s ++ "</text>\n";

let panelToPath: (panel, specs, float, float, float) => string =
  (p, sp, x, y, dipSize) => { 
      
    let bList = allBoxes(p.geom, sp, p.isHorizontal); 
    let dSpec = "d=\" \n" ++ boxListToPathD(bList, sp, dipSize) ++ "\""; 
    //let dSpec = "";
    let head = 
      "<g transform=\"translate("
      ++ sof(x)
      ++ ", "
      ++ sof(y)
      ++ ")\">\n"
      ++ text(20.0, 20.0, p.name)  
      ++ "<path id=\""
      ++ p.name
      ++ "\" vector-effect=\"non-scaling-stroke\" class=\"st0\" ";
    let tail = "/>\n</g>\n";
    head ++ dSpec ++ tail;
  };
 
let dividerToSVG: divider => string =
  dr => {
    let strokeWidth1 = "7.200000e-02";
    let color1= "#FF0000"
    let strokeWidth2 = "7.200000e-01";
    let color2= "#0000FF"
    let panelCount = List.length(dr.horiz) + List.length(dr.vert);
    let panelWidth =
      int_of_float(
        72.0
        *. List.fold_left(
             (x, y) => max(x, y),
             0.0,
             List.map(
               (p: panel) => panelLength(p.geom),
               List.append(dr.horiz, dr.vert),
             ),
           ),
      );
    let windowHeight =
      int_of_float(
        40.0 +. float_of_int(panelCount) *. 72.0 *. (dr.spec.height +. 0.125),
      );  
    
    let shapeString =
      "0 0 "
      ++ string_of_int(20 + panelWidth)
      ++ " "
      ++ string_of_int(windowHeight);

    let svgFront =
      "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
      ++ "<!-- Generator: Adobe Illustrator 24.1.2, SVG Export Plug-In . SVG Version: 6.00 Build 0)  -->\n"
      ++ "<svg version=\"1.1\" id=\"Layer_1\" xmlns=\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\" \n"
      ++ "x=\"0px\" y=\"0px\" viewBox=\""
      ++ shapeString
      ++ " \" style=\"enable-background:new "
      ++ shapeString
      ++ ";\" xml:space=\"preserve\">\n";
    let styleString1 = 
      "<style type=\"text/css\">\n"
      ++ ".st0{fill:none;stroke:" ++ color1 ++ ";stroke-width:"
      ++ strokeWidth1
      ++ ";stroke-linecap:round;stroke-miterlimit:288;}\n</style>\n";
    let styleString2 = 
      "<style type=\"text/css\">\n"
       ++ ".st0{fill:none;stroke:" ++ color2 ++ ";stroke-width:"
      ++ strokeWidth2
      ++ ";stroke-linecap:round;stroke-miterlimit:288;}\n</style>\n";

    let svgBack = "</svg>\n";

    let panelPathsH =
      List.mapi(
        (i, pan) =>
          panelToPath(
            pan,
            dr.spec,
            10.0,
            10.0 +. float_of_int(i) *. 72.0 *. (dr.spec.height +. 0.125), 
            dr.spec.dipSizeH
          ),
        dr.horiz,
      );
   
    let offset = (float_of_int(List.length(dr.horiz))+.0.2) *. 72.0 *. (dr.spec.height +. 0.125);
    let panelPathsV =
      List.mapi(
        (i, pan) =>
          panelToPath(
            pan, 
            dr.spec,
            10.0,
            10.0 +. float_of_int(i) *. 72.0 *. (dr.spec.height +. 0.125) +. offset,  
            dr.spec.dipSizeV
          ),
        dr.vert,
      ); 

    let back = List.fold_right((s1, s2) => s1 ++ s2, List.append(panelPathsH, panelPathsV), "");
    svgFront ++ styleString1 ++ back ++ styleString2 ++ back ++ svgBack;
  }; 
 
// let show: panel => unit =
//   p => {
//     print_string(p.name ++ ": ");
//     print_string(sof(panelLength(p.geom)) ++ "\n");
//   };





// //let sp: specs = {height: 2.0, dipSize: 1.5, t, pinCount: 5, tabFraction: 0.3};

let stringOfDivider: divider => string = dividerToSVG
