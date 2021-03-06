// Generated by ReScript, PLEASE EDIT WITH CARE


function updateCounter(s, count) {
  var init = s.data;
  return {
          data: {
            counter: count,
            thickness: init.thickness,
            width: init.width,
            depth: init.depth,
            height: init.height,
            spacing: init.spacing,
            includeEnclosure: init.includeEnclosure,
            dipPercentageH: init.dipPercentageH,
            dipPercentageV: init.dipPercentageV
          },
          svg: s.svg,
          newStart: s.newStart
        };
}

function updateStart(s, start) {
  return {
          data: s.data,
          svg: s.svg,
          newStart: start
        };
}

function updateThickness(s, t) {
  console.log("updating thickness");
  var init = s.data;
  var q_data = {
    counter: init.counter,
    thickness: t,
    width: init.width,
    depth: init.depth,
    height: init.height,
    spacing: init.spacing,
    includeEnclosure: init.includeEnclosure,
    dipPercentageH: init.dipPercentageH,
    dipPercentageV: init.dipPercentageV
  };
  var q_svg = s.svg;
  var q_newStart = s.newStart;
  var q = {
    data: q_data,
    svg: q_svg,
    newStart: q_newStart
  };
  console.log(q);
  return q;
}

function updateWidth(s, t) {
  var init = s.data;
  return {
          data: {
            counter: init.counter,
            thickness: init.thickness,
            width: t,
            depth: init.depth,
            height: init.height,
            spacing: init.spacing,
            includeEnclosure: init.includeEnclosure,
            dipPercentageH: init.dipPercentageH,
            dipPercentageV: init.dipPercentageV
          },
          svg: s.svg,
          newStart: s.newStart
        };
}

function updateDepth(s, t) {
  var init = s.data;
  return {
          data: {
            counter: init.counter,
            thickness: init.thickness,
            width: init.width,
            depth: t,
            height: init.height,
            spacing: init.spacing,
            includeEnclosure: init.includeEnclosure,
            dipPercentageH: init.dipPercentageH,
            dipPercentageV: init.dipPercentageV
          },
          svg: s.svg,
          newStart: s.newStart
        };
}

function updateHeight(s, t) {
  var init = s.data;
  return {
          data: {
            counter: init.counter,
            thickness: init.thickness,
            width: init.width,
            depth: init.depth,
            height: t,
            spacing: init.spacing,
            includeEnclosure: init.includeEnclosure,
            dipPercentageH: init.dipPercentageH,
            dipPercentageV: init.dipPercentageV
          },
          svg: s.svg,
          newStart: s.newStart
        };
}

function updateSpacing(s, t) {
  var init = s.data;
  return {
          data: {
            counter: init.counter,
            thickness: init.thickness,
            width: init.width,
            depth: init.depth,
            height: init.height,
            spacing: t,
            includeEnclosure: init.includeEnclosure,
            dipPercentageH: init.dipPercentageH,
            dipPercentageV: init.dipPercentageV
          },
          svg: s.svg,
          newStart: s.newStart
        };
}

function updateIncludeEnclosure(s, t) {
  var init = s.data;
  return {
          data: {
            counter: init.counter,
            thickness: init.thickness,
            width: init.width,
            depth: init.depth,
            height: init.height,
            spacing: init.spacing,
            includeEnclosure: t,
            dipPercentageH: init.dipPercentageH,
            dipPercentageV: init.dipPercentageV
          },
          svg: s.svg,
          newStart: s.newStart
        };
}

function updateDipPercentageH(s, t) {
  console.log("updating dip fraction");
  var init = s.data;
  return {
          data: {
            counter: init.counter,
            thickness: init.thickness,
            width: init.width,
            depth: init.depth,
            height: init.height,
            spacing: init.spacing,
            includeEnclosure: init.includeEnclosure,
            dipPercentageH: t,
            dipPercentageV: init.dipPercentageV
          },
          svg: s.svg,
          newStart: s.newStart
        };
}

function updateDipPercentageV(s, t) {
  console.log("updating dip fraction");
  var init = s.data;
  return {
          data: {
            counter: init.counter,
            thickness: init.thickness,
            width: init.width,
            depth: init.depth,
            height: init.height,
            spacing: init.spacing,
            includeEnclosure: init.includeEnclosure,
            dipPercentageH: init.dipPercentageH,
            dipPercentageV: t
          },
          svg: s.svg,
          newStart: s.newStart
        };
}

function updateSVGContents(s, text) {
  return {
          data: s.data,
          svg: text,
          newStart: s.newStart
        };
}

function reducer(state, action) {
  if (typeof action === "number") {
    return state;
  }
  switch (action.TAG | 0) {
    case /* ChangeValue */0 :
        return updateCounter(state, action.counter);
    case /* ChangeThickness */1 :
        return updateThickness(state, action._0);
    case /* ChangeWidth */2 :
        return updateWidth(state, action._0);
    case /* ChangeDepth */3 :
        return updateDepth(state, action._0);
    case /* ChangeHeight */4 :
        return updateHeight(state, action._0);
    case /* ChangeEnclosure */5 :
        return updateIncludeEnclosure(state, action._0);
    case /* ChangeSpacing */6 :
        return updateSpacing(state, action._0);
    case /* ChangeDipPercentageH */7 :
        return updateDipPercentageH(state, action._0);
    case /* ChangeDipPercentageV */8 :
        return updateDipPercentageV(state, action._0);
    case /* ChangeSVG */9 :
        return updateSVGContents(state, action._0);
    case /* ChangeStart */10 :
        return updateStart(state, action._0);
    
  }
}

var initialState = {
  data: {
    counter: 100,
    thickness: 0.198,
    width: 5.0,
    depth: 4.0,
    height: 1.5,
    spacing: 0.5,
    includeEnclosure: true,
    dipPercentageH: 0.0,
    dipPercentageV: 70.0
  },
  svg: "",
  newStart: true
};

export {
  initialState ,
  updateCounter ,
  updateStart ,
  updateThickness ,
  updateWidth ,
  updateDepth ,
  updateHeight ,
  updateSpacing ,
  updateIncludeEnclosure ,
  updateDipPercentageH ,
  updateDipPercentageV ,
  updateSVGContents ,
  reducer ,
  
}
/* No side effect */
