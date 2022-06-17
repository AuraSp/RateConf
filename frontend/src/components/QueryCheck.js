import React, { Fragment } from 'react'
import { useEffect, useState } from "react";
import axios from "axios";

const QueryCheck = () => {
  const [queryId, setQueryId] = useState('');
  const [response, setResponse] = useState([]);
  const [data, setData] = useState();

  const handleChangeQuery = event => {
    setQueryId(event.target.value);
  }

  const handleClick = event => {
    event.preventDefault();
    const data = JSON.stringify({
      id: queryId
    })

    console.log(data);

    const url = 'http://localhost:5000/api/v1/pdf_api' + '?id=' + queryId;

    axios.get(url, {
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Token Test',
        'Access-Control-Allow-Origin': "*",
      }
    }).then((res) => {
      setResponse(res.data);
      console.log(res.data.query[0]);
    }).catch((error) => {
      console.error(error)
    })
  };

  const updateData = () => {
    if (response.length !== 0) {
      if (response.query[0].status === "finished") {
        //console.log("finished!!!! :)))))))");
        const stringData = response.query[0].rate_conf_data;
        var requiredData = stringData.match(/"([^']+)"/)[0];
        var reg = /"(.*?)"/i;
        var allData = [];
        //15
        for (let i = 0; i < 15; i++) {
          allData.push(requiredData.match(reg)[1]);
          requiredData = requiredData.replace(requiredData.match(reg)[0], '')
        }
        //console.log(allData)
        console.log("JOb is finished");
        document.getElementById("jobStatus").innerHTML = "Job is finished."
        setData(response.query[0])
      }
      else if (response.query[0].status === "processing") {
        console.log("The Document is still being processed");
        document.getElementById("jobStatus").innerHTML = "The Document is still being processed."
        setData(response.query[0])
      }
    }
  }

  useEffect(() => {
    updateData();
  }, [response])

  console.log(data)

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
        <div>
          <h3 id='jobStatus'></h3>
          <p>{JSON.stringify(data.rate_conf_data)}</p>
        </div>
      </div>
    </div>
  )
}

export default QueryCheck