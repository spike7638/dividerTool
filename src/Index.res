%%raw(`import './index.css';`)

let rootQuery = ReactDOM.querySelector("#root")

switch rootQuery {
| None => ()
// | Some(root) =>  ReactDOM.render(<div> <Controls /><hr /><App /> <div> <Toolbar /> </div><Target /></div>, root)
// | Some(root) =>  ReactDOM.render(<div> <Controls /><hr /><Square /> <div> <Toolbar /> </div><Target /></div>, root)
| Some(root) =>  ReactDOM.render(<div> <AppMain /></div>, root)
}
// Note use of "App" twice above; has to be inside <div> </div> pair, because "render" takes
// a SINGLE piece of HTML, and just writing <App /> <App /> won't work, because that's
// two pieces. 

  