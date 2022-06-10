import Fields from "./components/Fields";
import UploadFile from "./components/UploadFile";
import Autofill from "./components/Autofill";


function App() {
  return (
    <div className="App">
      <header className="App-header">
        <Autofill/>
        <UploadFile/>
      </header>
    </div>
  );
}

export default App;
