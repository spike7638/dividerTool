// thickness of material
// width, depth
// height of dividers
// enclosed or not?
// dip percentage?

// update SVG button
// SVG Display text area

 let s = "<svg height=\"1000\" width=\"1000\">
 <rect width=\"300\" height=\"100\" style=\"fill:rgb(0,0,255);\" /> 
</svg>"

@react.component
let make = (~state: Types.state, ~dispatch: Store.action => unit) => {
  <main>
    <div className="SVGDisplay">
    <div dangerouslySetInnerHTML={"__html": DrawingToSVG.dividerToSVG(DrawingToSVG.drawingToDivider(state, EditorComponent.getStrokes()))} />
      // <svg  width="400" height="180">
      // {React.string(DrawingToSVG.dividerToSVG(DrawingToSVG.drawingToDivider(state, EditorComponent.getStrokes())))}
      // </svg>
    </div>
  </main> 
}
 