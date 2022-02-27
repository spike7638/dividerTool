
open Reprocessing;

type ss = {mutable val:int};
let s:ss = {val:100};
let (getValue:(unit => int)) = () => s.val;

type stateLocal = {width: int}
type action =
  | ChangeValue({width: int})

let {useReducer} = module (React.Uncurried)
let {string} = module (React)
let {render,querySelector} = module (ReactDOM )
let initialState = {width: 100}
let reducer = (state, action) =>
  switch action {
  | ChangeValue(w) => {width: w.width}
  }
 
 
@react.component
let make = (~state: Store.state, ~dispatch: Store.action => unit) => {
  let (stateLocal, dispatchLocal) = useReducer(reducer, initialState)


// @react.component
// let make = (~state: Store.state, ~dispatch: Store.action => unit) => {
  let id = "reprocessing-square"

let setup = (env) => {
  Env.size(~width=200 , ~height=200, env);
  s
};


let draw  = (s, env) => {
  Draw.background(Constants.red, env);
  Draw.fill(Constants.green, env);
 
  s.val = state.data.counter
  
  Draw.rect(~pos=(50, 50), ~width=s.val, ~height=100, env)
  s 
};


  React.useEffect(() => {
    setScreenId(id)
    run(~setup, ~draw, ())
    None
  })
  <canvas id /> 
}

 