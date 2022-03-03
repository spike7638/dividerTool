%%raw(`
import './App.css';
`)
 

@react.component
let make = () => {

  let (state, dispatch) = React.useReducer(Store.reducer, Store.initialState)
  (<div><Controls state dispatch/><hr/>
  <EditorComponent state dispatch/><hr/>
  <hr />
  <SVGDisplay state dispatch /> <hr />
  //<Scrap state dispatch/>  <hr/>
  </div>);
}