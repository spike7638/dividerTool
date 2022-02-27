// %%raw(`
// import './App.css';
// `)
// The "target" for the controls
// Controls: increase or decrease value by 10; display base value
// Target: take example from Controls and then increase or decrease it by 1. ; display computed value
// Example: if controls shows 20 and Target shows 23 ...
// .. and target+ button is pressed, Target shows 24. Then if controls+ button is pressed, 
// .. controls shows 30, and target shows 34. 
// So (roughly) Target's value is "local" and "Control's" value is part of global state
type stateLocal = {count: int}

let {useReducer} = module (React.Uncurried)
let {string} = module (React)
let {render,querySelector} = module (ReactDOM )
let initialState = {count: 0}
let reducer = (state, action) =>
  switch action {
  | #Increment => {count: state.count + 1}
  | #Decrement => {count: state.count - 1}
  }
 
 
@react.component
let make = (~state: Store.state, ~dispatch: Store.action => unit) => {
  let (stateLocal, dispatchLocal) = useReducer(reducer, initialState)
  <main>
    <div className="Controls">
      <header className="Controls-header">
        <div>
        <button onClick={_ => dispatchLocal(.#Decrement)}> {string("Decrement")} </button>

        <span className="counter"> {(state.data.counter + stateLocal.count)->string_of_int->string} </span>
       
        <button onClick={_ => dispatchLocal(.#Increment)}> {string("Increment")} </button>
      </div>
      </header>
    </div>
  </main>
}
