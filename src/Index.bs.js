// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as ReactDom from "react-dom";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as AppMain$DividerEditor from "./AppMain.bs.js";

import './index.css';
;

var rootQuery = document.querySelector("#root");

if (!(rootQuery == null)) {
  ReactDom.render(React.createElement("div", undefined, React.createElement(AppMain$DividerEditor.make, {})), rootQuery);
}

var rootQuery$1 = (rootQuery == null) ? undefined : Caml_option.some(rootQuery);

export {
  rootQuery$1 as rootQuery,
  
}
/*  Not a pure module */
