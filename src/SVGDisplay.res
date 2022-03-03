
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
    <div 
      className="SVGDisplay" 
      dangerouslySetInnerHTML={"__html": DrawingToSVG.dividerToSVG(DrawingToSVG.drawingToDivider(state, EditorComponent.getStrokes()))}>
 
    </div>
  </main> 
}
 