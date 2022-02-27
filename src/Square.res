open Reprocessing;

@react.component
let make = () => {
  let id = "reprocessing-square"

let setup = (env) => {
  Env.size(~width=200, ~height=200, env);
};

let draw = (_state, env) => {
  Draw.background(Constants.red, env);
  Draw.fill(Constants.green, env);
  Draw.rect(~pos=(50, 50), ~width=100, ~height=100, env)
};


  React.useEffect(() => {
    setScreenId(id)
    run(~setup, ~draw, ())
    None
  })
  <canvas id />
}