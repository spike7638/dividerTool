// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Caml_format from "rescript/lib/es6/caml_format.js";

function Controls(Props) {
  var state = Props.state;
  var dispatch = Props.dispatch;
  return React.createElement("main", undefined, React.createElement("div", {
                  className: "Controls"
                }, React.createElement("header", {
                      className: "Controls-header"
                    }, React.createElement("div", undefined, React.createElement("h2", undefined, "Dimensions (in inches)"), React.createElement("label", {
                              htmlFor: "thickness"
                            }, "Thickness "), React.createElement("input", {
                              id: "thickness",
                              max: "0.75",
                              min: "0",
                              name: "thickness",
                              step: 0.001,
                              type: "number",
                              value: state.data.thickness.toString(),
                              onChange: (function ($$event) {
                                  return Curry._1(dispatch, {
                                              TAG: /* ChangeThickness */1,
                                              _0: Number($$event.target.value)
                                            });
                                })
                            }), React.createElement("br", undefined), React.createElement("label", {
                              htmlFor: "drawerWidth"
                            }, "Drawer width "), React.createElement("input", {
                              id: "drawerWidth",
                              max: "60.0",
                              min: "0",
                              name: "width",
                              step: 0.001,
                              type: "number",
                              value: state.data.width.toString(),
                              onChange: (function ($$event) {
                                  return Curry._1(dispatch, {
                                              TAG: /* ChangeWidth */2,
                                              _0: Caml_format.caml_float_of_string($$event.target.value)
                                            });
                                })
                            }), React.createElement("br", undefined), React.createElement("label", {
                              htmlFor: "drawerDepth"
                            }, "Drawer depth "), React.createElement("input", {
                              id: "drawerDepth",
                              max: "60.0",
                              min: "0",
                              name: "depth",
                              step: 0.001,
                              type: "number",
                              value: state.data.depth.toString(),
                              onChange: (function ($$event) {
                                  return Curry._1(dispatch, {
                                              TAG: /* ChangeDepth */3,
                                              _0: Caml_format.caml_float_of_string($$event.target.value)
                                            });
                                })
                            }), React.createElement("br", undefined), React.createElement("label", {
                              htmlFor: "height"
                            }, "Divider height "), React.createElement("input", {
                              id: "height",
                              max: "6.0",
                              min: "0",
                              name: "height",
                              step: 0.001,
                              type: "number",
                              value: state.data.height.toString(),
                              onChange: (function ($$event) {
                                  return Curry._1(dispatch, {
                                              TAG: /* ChangeHeight */4,
                                              _0: Caml_format.caml_float_of_string($$event.target.value)
                                            });
                                })
                            }), React.createElement("br", undefined), React.createElement("label", {
                              htmlFor: "height"
                            }, "Space between dots "), React.createElement("input", {
                              id: "spacing",
                              max: "6.0",
                              min: "0",
                              name: "spacing",
                              step: 0.001,
                              type: "number",
                              value: state.data.spacing.toString(),
                              onChange: (function ($$event) {
                                  return Curry._1(dispatch, {
                                              TAG: /* ChangeHeight */4,
                                              _0: Caml_format.caml_float_of_string($$event.target.value)
                                            });
                                })
                            }), React.createElement("br", undefined), React.createElement("p", undefined, "The actual space between panels on adjacent dots is less than the dot-spacing by one material-thickness."), React.createElement("br", undefined), React.createElement("h2", undefined, "Options "), React.createElement("br", undefined), React.createElement("label", {
                              htmlFor: "dipPercentageV"
                            }, "Depth of dip as percentage of height (0 means 'no dip') for front-to-back panels"), React.createElement("input", {
                              id: "dipPercentageV",
                              max: "100",
                              min: "0",
                              name: "dipPercentageV",
                              type: "number",
                              value: state.data.dipPercentageV.toString(),
                              onChange: (function ($$event) {
                                  return Curry._1(dispatch, {
                                              TAG: /* ChangeDipPercentageV */7,
                                              _0: Caml_format.caml_float_of_string($$event.target.value)
                                            });
                                })
                            }), React.createElement("br", undefined), React.createElement("label", {
                              htmlFor: "dipPercentageH"
                            }, "Depth of dip as percentage of height for left-right panels"), React.createElement("input", {
                              id: "dipPercentageH",
                              max: "100",
                              min: "0",
                              name: "dipPercentageH",
                              type: "number",
                              value: state.data.dipPercentageH.toString(),
                              onChange: (function ($$event) {
                                  return Curry._1(dispatch, {
                                              TAG: /* ChangeDipPercentageH */6,
                                              _0: Caml_format.caml_float_of_string($$event.target.value)
                                            });
                                })
                            }), React.createElement("br", undefined), React.createElement("br", undefined), React.createElement("button", {
                              onClick: (function (param) {
                                  return Curry._1(dispatch, /* NoOp */0);
                                })
                            }, "Refresh SVG"), React.createElement("br", undefined), React.createElement("textarea", {
                              defaultValue: "When you press the 'refresh SVG' button, the results will appear here.",
                              id: "svgtext",
                              cols: 80,
                              name: "svgtext",
                              rows: 20
                            }), React.createElement("br", undefined)))));
}

var make = Controls;

export {
  make ,
  
}
/* react Not a pure module */
