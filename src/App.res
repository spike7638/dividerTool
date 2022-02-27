%%raw(`
import './App.css';
`)


@react.component
let make = () => {
  (
    <div className="App">
    
      <header className="App-header">
        <p>
        {React.string("Edit ")}
        <code>{React.string("src/App.res")}</code>
        {React.string(" and save to reload.")}
        </p>
        
      </header>
    </div> 
  );
}
