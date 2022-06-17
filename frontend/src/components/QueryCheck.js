import React, { Fragment } from 'react'
import { useEffect, useState } from "react";
import axios from "axios";

const QueryCheck = () => {
  const [queryId, setQueryId] = useState('');
  const [response, setResponse] = useState([]);

  const handleChangeQuery = event => {
    setQueryId(event.target.value);
  }

  const handleClick = event => {
    event.preventDefault();
    const data = JSON.stringify({
      id: queryId
    })

    console.log(data);

    const url = 'http://localhost:3000/api/v1/pdf_api' + '?id=' + queryId; 

    axios.get(url, {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token Test',
      }
    }).then((res) => {
      setResponse(res.data);
      console.log(res.data.query[0]);
    }).catch((error) => {
      console.error(error)
    })
  };

  const updateData = () => {
    if(response.length !== 0) {
      if(response.query[0].status === "finished") {
        //console.log("finished!!!! :)))))))");
        const stringData = response.query[0].rateConfData;
        var requiredData = stringData.match(/"([^']+)"/)[0];
        var reg = /"(.*?)"/i;
        var allData = [];
        //15
        for(let i = 0; i < 15; i++) {
          allData.push(requiredData.match(reg)[1]);
          requiredData = requiredData.replace(requiredData.match(reg)[0], '')
        }
        //console.log(allData)
        document.getElementById("jobStatus").innerHTML = "Job is finished."
        document.getElementById("responseData").innerHTML = allData;
      }
      else if(response.query[0].status === "processing") {
        console.log("The Document is still being processed");
        document.getElementById("jobStatus").innerHTML = "The Document is still being processed."
      }
    }
    
  }

  useEffect(() => {
    updateData();
  }, [response])

  return (
    <div>
      <div id="checkQuery">
      <h2>Check by entering your Query ID</h2>
          <form>
              <label>
                  <input id="queryIdInput" value={queryId} onChange={handleChangeQuery} type="text"></input>
              </label>
              <button id='requestButton' onClick={handleClick}>Click me</button>
          </form>
          <h3 id='jobStatus'></h3>
          <p id='responseData'></p>
          {updateData}
          
      </div>
    </div>
  )
}

export default QueryCheck