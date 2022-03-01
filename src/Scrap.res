let a = list{"a", "b"};

@react.component
let make = (~_state: Types.state, ~_dispatch: Store.action => unit) => {
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
