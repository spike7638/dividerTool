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
    <div className="Display">
      <header className="Display-header">
        <div>
        <span className="counter"> {("Counter: " ++ (state.data.counter->string_of_int))->React.string} </span>
        <br />
         <span > {("Thickness: " ++ (state.data.thickness->Js.Float.toString))->React.string} </span>
        <br />
         <span > {("Width: " ++ (state.data.width->Js.Float.toString))->React.string} </span>
        <br />
         <span > {("Depth: " ++ (state.data.depth->Js.Float.toString))->React.string} </span>
        <br />
         <span > {("Height: " ++ (state.data.height->Js.Float.toString))->React.string} </span>
        <br />
         <span > {("Enclosed?: " ++ (state.data.includeEnclosure->string_of_bool))->React.string} </span>
        <br />
         <span > {("Dip Fraction: " ++ (state.data.dipFraction->Js.Float.toString))->React.string} </span>
        <br />
        
      </div>
      <hr/>

      </header>
    </div>
  </main> 
}
