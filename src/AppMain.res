@react.component
let make = () => {
  let (state, dispatch) = React.useReducer(Store.reducer, Store.initialState)
  {
    <div>
      <Controls state dispatch />
      <hr />
      <pre>
      {React.string("Click and drag from dot to dot to draw horizontal or vertical panels in your divider. Use shift-click near a line segment to delete it. \n\
      The tan outline shows the actual region occupied by the divider, and may not extend all the way to the rightmost or topmost set of dots. \n\
      You may still draw a line to these 'outer' dots, and it will be trimmed to an appropriate length.")}
      </pre>
      <EditorComponent state dispatch />
      <hr />
      <p>
      {React.string("A visualization of the SVG file produced by the drawing-editor. The actual cut-lines, .001 thick, are drawn in pure red; they're overdrawn\n
      in .01-thick blue to make them easy to see here, and you should therefore set your laser-cutter to NOT do any cutting for blue strokes. Labels for each
      panel are drawn in pure green. If you want your panels labelled, you could set your laser cutter to do a very faint 'fill' for pure-green items, which you 
      could then sand off. Because the pieces are simply stacked up, you will probably want to open the SVG file in some editor like Inkscape or Adobe Illustrator
      to place them more suitably for your stock.")}
      </p>
      <SVGDisplay state dispatch />
    </div>
  }
}
