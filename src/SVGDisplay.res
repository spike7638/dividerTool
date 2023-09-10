// thickness of material
// width, depth
// height of dividers
// enclosed or not?
// dip percentage?

// update SVG button
// SVG Display text area

@react.component
let make = (~state: Types.state, ~dispatch: Store.action => unit) => {
  React.useEffect(() => {
    //let i = 17;
    None
  })
  //dispatch(Store.NoOp);

  {
    <main>
      <div
        className="SVGDisplay"
        dangerouslySetInnerHTML={
          "__html": DrawingToSVG.dividerToSVG(
            DrawingToSVG.drawingToDivider(state, EditorComponent.getStrokes()),
          ),
        }
      />
      <p> {React.string(string_of_bool(state.newStart))} </p>
    </main>
  }
}
