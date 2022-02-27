// thickness of material
// width, depth
// height of dividers
// enclosed or not?
// dip percentage?

// update SVG button
// SVG Display text area

 
@react.component
let make = (~state: Store.state, ~dispatch: Store.action => unit) => {
  <main>
    <div className="Controls">
      <header className="Controls-header">
        <div>
        <button onClick={_ => {          
          dispatch(
            Store.ChangeValue({counter:state.data.counter - 10}),
          )  
        }}> 
        {React.string("Decrement")} 
        </button>

        <span className="counter"> {state.data.counter->string_of_int->React.string} </span>
        
        <button onClick={ _ => {
          dispatch(
            Store.ChangeValue({counter:state.data.counter + 10}),
          )
        }}> 
        {React.string("Increment")} 
        </button>
      </div>
      <hr/>


      <div>
      // <form>
      // <h2>  {React.string("Dimensions")} </h2>
      //   <label htmlFor="thickness" > {React.string("Thickness (in inches) ")} </label>
      //   <input type_="number" id="thickness" 
      //     name="thickness" 
      //     value ={Js.Float.toString(state.data.thickness)}
      //     onChange={event => {
      //       dispatch(
      //         Store.ChangeThickness(ReactEvent.Form.target(event)["value"])
      //       )
      //   }} 
      //     step=0.01 min="0" max="0.75"></input>
      //   <br />
      //   <label htmlFor="drawerWidth" > {React.string("Drawer width (in inches) ")} </label>
      //   <input type_="number" id="drawerWidth" name="width" 
      //     value ={Js.Float.toString(state.data.width)}
      //     onChange={event => {
      //       dispatch(
      //         Store.ChangeWidth(ReactEvent.Form.target(event)["value"])
      //       )
      //     }}
      //     step=0.01 min="0" max="60.0"></input>
      //   <br />
      //   <label htmlFor="drawerDepth" > {React.string("Drawer depth (in inches) ")} </label>
      //   <input type_="number" id="drawerDepth" name="depth" 
      //   value ={Js.Float.toString(state.data.depth)}
      //     onChange={event => {
      //       dispatch(
      //         Store.ChangeDepth(ReactEvent.Form.target(event)["value"])
      //       )
      //     }}
      //     step=0.01 min="0" max="60.0"></input>
      //   <br />
      //   <label htmlFor="height" > {React.string("Divider height (in inches) ")} </label>
      //   <input type_="number" id="height" name="height" 
      //   value ={Js.Float.toString(state.data.height)}
      //     onChange={event => {
      //       dispatch(
      //         Store.ChangeHeight(ReactEvent.Form.target(event)["value"])
      //       )
      //     }}
      //     step=0.01 min="0" max="6.0"></input>
      //   <br />
      //   <h2>  {React.string("Options ")} </h2>
      //   <label htmlFor="enclosed" > {React.string("Include outside enclosure")} </label>
      //   <input type_="checkbox" id="enclosed" name="enclosed" 
      //     value = "false" // XXX BRoken; need to figure out how to test whether it's checked or not
      //      onChange={event => {
      //       dispatch(
      //         Store.ChangeEnclosure((1/0 > 10)? false: ReactEvent.Form.target(event)["value"])
      //       )
      //     }} >
      //     </input>
      //   <br />
      //   <label htmlFor="dipFraction" > {React.string("Depth of dip as percentage of height (0 means 'no dip')")} </label>
      //   <input type_="number" id="dipFractions" name="dipFraction"  
      //   value ={Js.Float.toString(state.data.dipFraction)}
      //     onChange={event => {
      //       dispatch(
      //         Store.ChangeDipFraction(ReactEvent.Form.target(event)["value"])
      //       )
      //     }}
      //     min="0" max="100"></input>
      //   <br />
      //   <h2>  {React.string("SVG Result ")} </h2>
      //   <br />
      //   // <label htmlFor="svgtext" > {React.string("q")} </label>
      //   <button id="refreshSVG">{React.string("Refresh SVG")}</button> 
      //   <br/>
      //   <label htmlFor="svgtext" > {React.string("SVG Result")} </label>
      //  <textarea id="svgtext" name="svgtext" rows=20 cols=80>
      //  {React.string("When you press the 'refresh SVG' button, the results will appear here.")} 
      //  </textarea>
      //  <br/>
      //   </form>
      </div>
      </header>
    </div>
  </main> 
}
