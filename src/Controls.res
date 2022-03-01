// thickness of material
// width, depth
// height of dividers
// enclosed or not?
// dip percentage?

// update SVG button
// SVG Display text area
 
 
@react.component
let make = (~state: Types.state, ~dispatch: Store.action => unit) => {
  <main>
    <div className="Controls">
      <header className="Controls-header">
      //   <div>
      //   <button onClick={_ => {          
      //     dispatch(
      //       Store.ChangeValue({counter:state.data.counter - 10}),
      //     )  
      //   }}> 
      //   {React.string("Decrement")} 
      //   </button>

      //   <span className="counter"> {state.data.counter->string_of_int->React.string} </span>
        
      //   <button onClick={ _ => {
      //     dispatch(
      //       Store.ChangeValue({counter:state.data.counter + 10}),
      //     )
      //   }}> 
      //   {React.string("Increment")} 
      //   </button>
      // </div>
      // <hr/>


      <div>
      //<form>
      <h2>  {React.string("Dimensions (in inches)")} </h2>
        <label htmlFor="thickness" > {React.string("Thickness ")} </label>
        <input type_="number" id="thickness" 
          name="thickness" 
          value ={Js.Float.toString(state.data.thickness)}
          onChange={event => {
            dispatch(
              Store.ChangeThickness(Js.Float.fromString(ReactEvent.Form.target(event)["value"]))
            )
        }} 
          step=0.001 min="0" max="0.75"></input>
        <br />
        <label htmlFor="drawerWidth" > {React.string("Drawer width ")} </label>
        <input type_="number" id="drawerWidth" name="width" 
          value ={Js.Float.toString(state.data.width)}
          onChange={event => {
            dispatch(
              Store.ChangeWidth(float_of_string(ReactEvent.Form.target(event)["value"]))
            )
          }}
          step=0.001 min="0" max="60.0"></input>
        <br />
        <label htmlFor="drawerDepth" > {React.string("Drawer depth ")} </label>
        <input type_="number" id="drawerDepth" name="depth" 
        value ={Js.Float.toString(state.data.depth)}
          onChange={event => {
            dispatch(
              Store.ChangeDepth(float_of_string(ReactEvent.Form.target(event)["value"]))
            )
          }}
          step=0.001 min="0" max="60.0"></input>
        <br />
        <label htmlFor="height" > {React.string("Divider height ")} </label>
        <input type_="number" id="height" name="height" 
        value ={Js.Float.toString(state.data.height)}
          onChange={event => {
            dispatch(
              Store.ChangeHeight(float_of_string(ReactEvent.Form.target(event)["value"]))
            )
          }}
          step=0.001 min="0" max="6.0"></input>
        <br />
        <label htmlFor="spacing" > {React.string("Space between dots ")} </label>
        <input type_="number" id="spacing" name="spacing" 
        value ={Js.Float.toString(state.data.spacing)}
          onChange={event => {
            dispatch(
              Store.ChangeSpacing(float_of_string(ReactEvent.Form.target(event)["value"]))
            )
          }}
          step=0.001 min="0" max="6.0"></input>
          <br/>
          <p>
        {React.string("The actual space between panels on adjacent dots is less than the dot-spacing by one material-thickness.")}
        </p>
        <br />
        <h2>  {React.string("Options ")} </h2>
        // <label htmlFor="enclosed" > {React.string("Include outside enclosure")} </label>
        // <input type_="checkbox" id="enclosed" name="enclosed" 
        //   value = "false" // XXX BRoken; need to figure out how to test whether it's checked or not
        //    onChange={event => {
        //     dispatch(
        //       Store.ChangeEnclosure("true" == (ReactEvent.Form.target(event)["value"]))
        //     )
        //   }} >
        //   </input>
        <br /> 
        <label htmlFor="dipPercentageV" > {React.string("Depth of dip as percentage of height (0 means 'no dip') for front-to-back panels")} </label>
        <input type_="number" id="dipPercentageV" name="dipPercentageV"  
        value ={Js.Float.toString(state.data.dipPercentageV)}
          onChange={event => {
            dispatch(
              Store.ChangeDipPercentageV(float_of_string(ReactEvent.Form.target(event)["value"]))
            )
          }}
          min="0" max="100"></input>
          <br />
          <label htmlFor="dipPercentageH" > {React.string("Depth of dip as percentage of height for left-right panels")} </label>
        <input type_="number" id="dipPercentageH" name="dipPercentageH"  
        value ={Js.Float.toString(state.data.dipPercentageH)}
          onChange={event => {
            dispatch(
              Store.ChangeDipPercentageH(float_of_string(ReactEvent.Form.target(event)["value"]))
            )
          }}
          min="0" max="100"></input>
          <br />
        // <h2>  {React.string("SVG Result ")} </h2>
        <br />
        // <label htmlFor="svgtext" > {React.string("q")} </label>
        <button onClick={_ => {          
          dispatch(
            Store.ChangeDrawing(EditorComponent.getStrokes()),
          )  
        }}> {React.string("Refresh SVG" ++ string_of_int(List.length(EditorComponent.getStrokes())))}</button> 
        <br/>
        <p style={ReactDOM.Style.make(~padding="10px", ~fontSize="12pt", ~border="2px", ~color="black", ())}>
//        {React.string(EditorComponent.stringOfStrokes("current strokes", EditorComponent.getStrokes()))}
        {React.string(DrawingToSVG.dividerToSVG(DrawingToSVG.drawingToDivider(state, EditorComponent.getStrokes())))}
        </p> 

      //  <textarea id="svgtext" name="svgtext" defaultValue="When you press the 'refresh SVG' button, the results will appear here." rows=20 cols=80>
      //  {React.string("Dummy to overwrite default")} 
       //{React.string(EditorComponent.stringOfStrokes("current strokes", EditorComponent.getStrokes()))} 
      //  </textarea>
       <br/>
       // </form>
      </div>
      </header>
    </div>
  </main> 
}
