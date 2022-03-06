%%raw(`import './index.css';`)

let rootQuery = ReactDOM.querySelector("#root")

switch rootQuery {
| None => ()
// | Some(root) =>  ReactDOM.render(<div> <Controls /><hr /><App /> <div> <Toolbar /> </div><Target /></div>, root)
// | Some(root) =>  ReactDOM.render(<div> <Controls /><hr /><Square /> <div> <Toolbar /> </div><Target /></div>, root)
| Some(root) =>  ReactDOM.render(<div> <AppMain /></div>, root)
}
// Note that the argument to render is within a <div> </div> pair, because "render" takes
// a SINGLE piece of HTML, and just writing <App /> <App /> (or anything like that)
// won't work, because that's two pieces.   