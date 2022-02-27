
@react.component
let make = (~state: Store.state, ~dispatch: Store.action => unit) => {
  <main>
    <div className="Scrap">
      <header className="Scrap-header">
        <div>
          <button > {React.string("Show width")} </button>
          <span className="width"> {Target2.getValue()->string_of_int->React.string} </span>
        </div>
      </header>
    </div>
  </main>
}
