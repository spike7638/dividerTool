%%raw(`
import './Controls.css';
`)


let tooltipLabel = (target, labelText, tooltipText) => 
  {
    <div className="tooltip"> 
      <label htmlFor={"\""++target++"\""}> {React.string(labelText)} </label>
      <span className="tooltiptext"> {React.string(tooltipText)} </span>
    </div>
  }

@react.component
let make = (~state: Types.state, ~dispatch: Store.action => unit) => {
  <main>
    <div className="Controls">
      <header className="Controls-header">
        <div>
          <h3> {React.string("Dimensions (in inches)")} </h3>
          {tooltipLabel("thickness", "Thickness ", "The thickness of the material used for making dividers. For 3mm plywood, for instance, 0.19 is approximately correct.")}
          <input
            type_="number"
            id="thickness"
            name="thickness"
            value={Js.Float.toString(state.data.thickness)}
            onChange={event => {
              dispatch(
                Store.ChangeThickness(Js.Float.fromString(ReactEvent.Form.target(event)["value"])),
              )
            }}
            step=0.001
            min="0"
            max="0.75"
          />
          <br />
          {tooltipLabel("drawerWidth", "Drawer width ", "The overall side-to-side measurement of the divider assembly, typically the width of the drawer in which it sits, minus perhaps .01 inch")}
//          <label htmlFor="drawerWidth"> {React.string("Drawer width ")} </label>
          <input
            type_="number"
            id="drawerWidth"
            name="width"
            value={Js.Float.toString(state.data.width)}
            onChange={event => {
              dispatch(Store.ChangeWidth(float_of_string(ReactEvent.Form.target(event)["value"])))
            }}
            step=0.001
            min="0"
            max="60.0"
          />
          <br />
          {tooltipLabel("drawerDepth", "Drawer depth ", "The overall front-to-back measurement of the divider assembly, typically the depth of the drawer in which it sits, minus perhaps .01 inch")}
          //<label htmlFor="drawerDepth"> {React.string("Drawer depth ")} </label>
          <input
            type_="number"
            id="drawerDepth"
            name="depth"
            value={Js.Float.toString(state.data.depth)}
            onChange={event => {
              dispatch(Store.ChangeDepth(float_of_string(ReactEvent.Form.target(event)["value"])))
            }}
            step=0.001
            min="0"
            max="60.0"
          />
          <br />
            {tooltipLabel("height", "Divider height ", "The height of the divider assembly at its highest point (typically a crossing of panels)")}
//  <label htmlFor="height"> {React.string("Divider height ")} </label>
          <input
            type_="number"
            id="height"
            name="height"
            value={Js.Float.toString(state.data.height)}
            onChange={event => {
              dispatch(Store.ChangeHeight(float_of_string(ReactEvent.Form.target(event)["value"])))
            }}
            step=0.001
            min="0"
            max="6.0"
          />
          <br />
         {tooltipLabel("spacing", "Distance between dots ", "The distance between dots in the divider drawing. The is also smallest distance between panel-centers. The distance between panels drawn through adjacent dots is this amount, MINUS one panel-thickness. So if the dot-spacing is 1 inch, and you are using 1/4-inch material, the gap between adjacent panels will be only 3/4 of an inch.
         ")}
//
        //  <label htmlFor="spacing"> {React.string("Space between dots ")} </label>
          <input
            type_="number"
            id="spacing"
            name="spacing"
            value={Js.Float.toString(state.data.spacing)}
            onChange={event => {
              dispatch(Store.ChangeSpacing(float_of_string(ReactEvent.Form.target(event)["value"])))
            }}
            step=0.001
            min="0"
            max="6.0"
          />
          <br />
          {tooltipLabel("restart", "Restart design", "Press this button to remove all panels from the current design (except for the four outer panels, which are always there at the start, but which you can easily remove if you like); you probably want to do this if (and only if) you've changed the dot-spacing, width, or depth.")}
          <button id="restart"
            onClick={_ => {
              dispatch(Store.ChangeStart(true));
              //dispatch(Store.ChangeDrawing(list{}))
              dispatch(Store.ChangeStart(false));
            }}>
            {React.string("Restart Design")}
          </button>
          <br />
          <br />
          <h3> {React.string("Options ")} </h3>
          <label htmlFor="dipPercentageV">
            {React.string(
              "Depth of dip as percentage of height (0 means 'no dip') for front-to-back panels ",
            )}
          </label>
          <input
            type_="number"
            id="dipPercentageV"
            name="dipPercentageV"
            value={Js.Float.toString(state.data.dipPercentageV)}
            onChange={event => {
              dispatch(
                Store.ChangeDipPercentageV(float_of_string(ReactEvent.Form.target(event)["value"])),
              )
            }}
            min="0"
            max="100"
          />
          <br />
          <label htmlFor="dipPercentageH">
            {React.string("Depth of dip as percentage of height for left-right panels ")}
          </label>
          <input
            type_="number"
            id="dipPercentageH"
            name="dipPercentageH"
            value={Js.Float.toString(state.data.dipPercentageH)}
            onChange={event => {
              dispatch(
                Store.ChangeDipPercentageH(float_of_string(ReactEvent.Form.target(event)["value"])),
              )
            }}
            min="0"
            max="100"
          />
          <br />
  
          {tooltipLabel("refresh", "Refresh SVG   ", "Press this button to both show the text of the SVG description produced\
          by the current drawing (in the tan box), and to update the visualization of that SVG below the drawing-editor.")}

          <button id="refresh"
            onClick={_ => {
              dispatch(Store.ChangeDrawing(EditorComponent.getStrokes()))
            }}>
            {React.string("Refresh SVG")}
          </button>
          <br />
          <div className="svgtext1">
            <pre type_="svgtext" className="svgtext">
              {React.string(
                DrawingToSVG.dividerToSVG(
                  DrawingToSVG.drawingToDivider(state, EditorComponent.getStrokes()),
                ),
              )}
            </pre>
          </div>
        </div>
      </header>
    </div>
  </main>
}
