%%raw(`
import './App.css';
`)
 

@react.component
let make = () => {

  let (state, dispatch) = React.useReducer(Store.reducer, Store.initialState)

  // React.useEffect1(() => {
  //   dispatch(
  //     Store.ChangeValue({
  //       counter:113
  //     }),
  //   )
  //   None
  // }, [dispatch])
//  (<div><Controls state dispatch/><hr/><Display state dispatch/><hr /><Target state dispatch/> <hr/> <Target2 state dispatch/><hr/> <hr/></div>);
  (<div><Controls state dispatch/><hr/><Target2 state dispatch/><hr/><Scrap state dispatch/>  <hr/></div>);
}

// let make = () => {
//   (
//     <div className="App">
    
//       <header className="App-header">
//         <p>
//         {React.string("Edit ")}
//         <code>{React.string("src/App.res")}</code>
//         {React.string(" and save to reload.")}
//         </p>
        
//       </header>
//     </div> 
//   );
// }
