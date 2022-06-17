import Input from "./components/Input";
import QueryCheck from "./components/QueryCheck";
import Header from "./components/Header"

function App() {
  return (
    <div className="App">
      <div className="header">
        <Header/> 
      </div>
      <div className="body">
      <Input/>
      <QueryCheck/>
      </div>
      <div className="footer"></div>
    </div>
  );
}

export default App;
