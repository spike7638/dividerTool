open Belt

type settings = {
  counter: int, // add more later
  thickness: float,
  width: float,
  depth: float,
  height: float,
  includeEnclosure: bool,
  dipFraction: float,
 }

type state = {
  data: settings,
  svg: string,
  // add another field here -- probably using Belt.Map.String (or just Belt.Map) as https://github.com/dusty-phillips/rescript-react-intro src/Store.res --
  // to save the current state of the drawing, even if the user resizes the drawer, etc. 
}

let initialState: state = {
  data: {counter:100, thickness: 0.198, width: 15.25, depth: 18.0, height: 1.5, includeEnclosure: true, dipFraction: 0.7},
  svg: "", 
}

type action =
  | ChangeValue({counter: int})
  | ChangeThickness(float)
  | ChangeWidth(float)
  | ChangeDepth(float)
  | ChangeHeight(float)
  | ChangeEnclosure(bool)
  | ChangeDipFraction(float)
  | UpdateSVG

let updateCounter: (state, int) => state = (s:state, count: int) => {
  {
    // data: {counter: count},
    data: {...s.data, counter: count,},
    svg: "",
  }
}
let updateThickness: (state, float) => state = (s:state, t: float) => {
  {
    data: {...s.data, thickness: t},
    svg: "",
  }
}
let updateWidth: (state, float) => state = (s:state, t: float) => {
  {
    data: {...s.data, width: t},
    svg: "",
  }
}
let updateDepth: (state, float) => state = (s:state, t: float) => {
  {
    data: {...s.data, depth: t},
    svg: "",
  }
}
let updateHeight: (state, float) => state = (s:state, t: float) => {
  {
    data: {...s.data, height: t},
    svg: "",
  }
}
let updateIncludeEnclosure: (state, bool) => state = (s:state, t: bool) => {
  {
    data: {...s.data, includeEnclosure: t},
    svg: "",
  }
}
let updateDipFraction: (state, float) => state = (s:state, t: float) => {
  {
    data: {...s.data, dipFraction: t},
    svg: "",
  }
}

let updateSVGContents: (state) => state = (s:state) => {
  {
    data: s.data,
    svg: "", // XXX Fix this -- need to get SVG string from theReProcessing code
  }
}


let reducer = (state: state, action: action) => {
  switch action {
  | ChangeValue({counter}) => updateCounter(state, counter)
  | ChangeThickness(t) => updateThickness(state, t)
  | ChangeWidth(t) => updateWidth(state, t)
  | ChangeDepth(t) => updateDepth(state, t)
  | ChangeHeight(t) => updateHeight(state, t)
  | ChangeEnclosure(t) => updateIncludeEnclosure(state, t)
  | ChangeDipFraction(t) => updateDipFraction(state, t)
  | UpdateSVG => updateSVGContents(state)
  }
}
