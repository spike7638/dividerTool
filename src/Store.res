open Types



let initialState: state = {
  data: {counter:100, thickness: 0.198, width: 5.0, depth: 4.0, height: 1.5, 
  includeEnclosure: true, dipPercentageV: 70.0, dipPercentageH: 0.0, spacing: 0.5},
  svg: "", drawing: list{}, newStart: true
}

type action =
  | ChangeValue({counter: int})
  | ChangeThickness(float)
  | ChangeWidth(float)
  | ChangeDepth(float)
  | ChangeHeight(float)
  | ChangeEnclosure(bool)
  | ChangeSpacing(float)
  | ChangeDipPercentageH(float)
  | ChangeDipPercentageV(float)
  | ChangeSVG(string)
  | ChangeDrawing(drawing)
  | ChangeStart(bool)
  | NoOp

let updateCounter: (state, int) => state = (s:state, count: int) => {
  {
    ...s,
    data: {...s.data, counter: count,}, 
  }
}

let updateStart: (state, bool) => state = (s:state, start: bool) => {
  {
    ...s,
    newStart: start, 
  }
}
let updateThickness: (state, float) => state = (s:state, t: float) => {
  Js.log("updating thickness");
  let q = {
    ...s,
    data: {...s.data, thickness: t},
  }
  Js.log(q);
  q 
}
let updateWidth: (state, float) => state = (s:state, t: float) => {
  {
    ...s,
    data: {...s.data, width: t},
  }
}
let updateDepth: (state, float) => state = (s:state, t: float) => {
  {
    ...s, 
    data: {...s.data, depth: t},
  }
}
let updateHeight: (state, float) => state = (s:state, t: float) => {
  {
    ...s,
    data: {...s.data, height: t},
  }
}
let updateSpacing: (state, float) => state = (s:state, t: float) => {
  {
    ...s,
    data: {...s.data, spacing: t},
  }
}
let updateIncludeEnclosure: (state, bool) => state = (s:state, t: bool) => {
  {
    ...s, 
    data: {...s.data, includeEnclosure: t},
  }
}
let updateDipPercentageH: (state, float) => state = (s:state, t: float) => {
  Js.log("updating dip fraction");
  {
    ...s,
    data: {...s.data, dipPercentageH: t},
  }
}

let updateDipPercentageV: (state, float) => state = (s:state, t: float) => {
  Js.log("updating dip fraction");
  {
    ...s,
    data: {...s.data, dipPercentageV: t},
  }
}

let updateSVGContents: (state, string) => state = (s:state, text:string) => {
  {
    ...s,
    svg: text,
  }
}

let updateDrawing: (state, drawing) => state = (s:state, d:drawing) => {
   Js.log("updateDrawing, pre-change state = ");
   Js.log(s);
  {
    ...s,
    drawing: d,
  }
}


let reducer = (state: state, action: action) => {
  switch action {
  | ChangeValue({counter}) => updateCounter(state, counter)
  | ChangeThickness(t) => updateThickness(state, t)
  | ChangeWidth(t) => updateWidth(state, t)
  | ChangeDepth(t) => updateDepth(state, t) 
  | ChangeHeight(t) => updateHeight(state, t) 
  | ChangeSpacing(t) => updateSpacing(state, t)
  | ChangeEnclosure(t) => updateIncludeEnclosure(state, t)
  | ChangeDipPercentageH(t) => updateDipPercentageH(state, t)
  | ChangeDipPercentageV(t) => updateDipPercentageV(state, t)
  | ChangeSVG(t) => updateSVGContents(state, t)
  | ChangeDrawing(t) => updateDrawing(state, t)
  | ChangeStart(t) => updateStart(state, t)
  | NoOp => state
  }
}
