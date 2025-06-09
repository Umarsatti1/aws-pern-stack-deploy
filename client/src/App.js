import './App.css';
import React, { Fragment } from "react";
import InputItems from "./components/InputItems";
import ListItems from './components/ListItems';


function App() {
  return (
    <Fragment>
      <div className="container">
        <InputItems/>
        <ListItems/>
      </div> 
    </Fragment>
  )
}

export default App;
