open Types;

// Local types
type f = float; 
type direction = H | V;
type meeting = Cross | Terminate | End; // does a crossing span meet the main span by Crossing it, or by terminating at it? 
    // or is this a "virtual" meeting at one of the two ends of the span? 
type spanSummary = {m:meeting, pos:int}

// XXX Things to link to other parts 
let frameWidth = 220.0; 
let gridSpacing = 30.0;
let thickness = 5.0;
let t = thickness;

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

let gToWH = converterProducer(frameWidth, gridSpacing, thickness);

let classifyH: (int, list(span)) => list(spanSummary) =
  (y, spans) => List.map(s => {m:(s.p1.yi == y || s.p2.yi == y) ? Terminate:Cross, pos:s.p1.xi}, spans);

let rec convertHelper:(int, int, int, list(spanSummary)) => list(feature) = (ss, sf, n, meets) => {
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
        [XU(t), G(gToWH(sf) -. gToWH(n))];
      } else {
        [T(t)];
      }
    | Terminate =>
      if (sf != n) {
        [S(t), G(gToWH(sf) -. gToWH(n))];
      } else {
        [CU(t)];
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
    | End => [fill, ...convertHelper(ss, sf, l, [{m: r, pos: l}, ...tl])]
    | Cross => if (k != ss){
        [
        XU(t),
        fillShort,
        ...convertHelper(ss, sf, l, [{m: r, pos: l}, ...tl]),
      ]
    } else {
        [
        T(t),
        fillShort,
        ...convertHelper(ss, sf, l, [{m: r, pos: l}, ...tl]),
      ]
    }
    | Terminate =>
      if (k == ss) {
        [
          CU(t),
          fillShort,
          ...convertHelper(ss, sf, l, [{m: r, pos: l}, ...tl]),
        ];
      } else {
        [
          S(t),
          fillShort,
          ...convertHelper(ss, sf, l, [{m: r, pos: l}, ...tl]),
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

let convertOne: (span, list(span)) => list(feature) = (s, spans) => {
    let span1 = classifyH(s.p1.yi, spans);
    let spanSummaries = enhance(s, span1);
    cleanup(convertHelper(s.p1.xi, s.p2.xi, s.p1.xi, spanSummaries));
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
let prepAndConvert: (list(span), list(span)) => list(list(feature)) = (hSpans, vSpans) => {
    let qq: span => list(feature)=  s => 
    {
        let crosses = List.filter(v => meets(s, v), vSpans)
        let cross2 = List.sort((s1, s2) => compare(s1.p1.xi, s2.p1.xi), crosses)
        convertOne(s, cross2)
    }
    List.fold_right((x, r) => [qq(x), ... r], hSpans, []);
}
// convertAll: do cleanup; sort into H and V; for each H apply convertOne; for each V apply the analogous thing. 
let convertAll: list(span) => list(list(feature)) = drawing => {
    let d = List.map(polish, drawing); //make sure spans are in increasing order
    let dH = List.filter(isHorizontal, d);
    let dV = List.filter(x => !isHorizontal(x), d);

    let fH = prepAndConvert(dH, dV);
    let fV = flipFeatureListList(prepAndConvert(flipSpanList(dV), flipSpanList(dH)));
    fH @ fV
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
let sof = string_of_float
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

let converter: list(stroke) => list(list(feature)) = sl =>
convertAll(spanList_of_strokeList(sl));

// example usage
// let description = convertAll(drawing); 
