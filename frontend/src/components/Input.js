import React from "react";
import { useEffect, useState } from "react";
import axios from "axios";

const Input = () => {
  const [base64x, setBase64x] = useState('');
  const [base64, setBase64] = useState('');
  const [company, setCompany] = useState('');
  const [queryUUID, setQueryUUID] = useState('')

  let base64Encoded = ''

  const handleChangeCompany = event => {
    setCompany(event.target.value)
  }

  const handleClick = event => {
    event.preventDefault();
    const data = JSON.stringify({
        pdfBase64: base64x,
        company: company
    })
    axios.post('http://localhost:5000/api/v1/pdf_api', data, {
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token Test',
            'Access-Control-Allow-Origin': "*",
        }
    }).then((res) => {
        console.log(res.data.queryUUID);
        setQueryUUID(res.data.queryUUID)

    }).catch((error) => {
        console.error(error);
    })
  };

  const handleFileRead = async (event) => {
      const file = event.target.files[0];
      base64Encoded = await convertBase64(file);
      setBase64x(base64Encoded.substring(28));
  }

  

  const convertBase64 = (file) => {
      return new Promise((resolve, reject) => {
          const fileReader = new FileReader();
          fileReader.readAsDataURL(file);
          fileReader.onload = () => {
              resolve(fileReader.result);
          }
          fileReader.onerror = (error) => {
              reject(error);
          }
      });
  }


  useEffect(() => {
    //console.log(base64x)
  }, [base64x])

  return (
    <div>
        <div id="forms">
        <form >
        <label>
          <input id='base64Input' value={base64} onChange={handleFileRead} type="file"></input>
        </label>
        <label>
          Company:
          <input id='companyInput' value={company} onChange={handleChangeCompany} type="text" name="company"></input>
        </label>
        <button id='requestButton' onClick={handleClick}>Click me</button>
      </form>
        </div>
      

      <div id="responseQuery">
          <h2 id="queryId"> {queryUUID} </h2>
      </div>
    </div>
  );
};

export default Input;
