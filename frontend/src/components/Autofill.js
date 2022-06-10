import React from 'react'
import { useState, useEffect } from 'react';
import Fields from './Fields';

const Autofill = () => {
    const [data, setData] = useState([]);

    const getData=() => {
        fetch('http://localhost:3000/api/v1/autofill', {
            headers : {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            }
        }).then(function(response){
            console.log(response);
            return response.json();
        }).then(function(myJson) {
            console.log(myJson);
            setData(myJson);
        })
    }

    useEffect(() => {
        getData()
    }, [])

    return (
        <Fields data={data}/>
    )
    
}

export default Autofill