import React from 'react'
import Autofill from './Autofill'

import { useState, useEffect } from 'react'

const Fields = ( {data} ) => {

  const [fieldData, setFieldData] = useState(data);

  useEffect(() => {
      setFieldData(data);
  }, [data]);

  const handleChange = e => {
      setFieldData({
          [e.target.name]: e.target.value
      });
  }

  return (
    <div>
        <form>
            <label id='name-field'>
                Name:
                <input id='name-input' type="text" name="name" value={fieldData.name} onChange={handleChange}/>
            </label>
            <label id='surname-field'>
                Surname:
                <input id='surname-input' type="text" name="surname" value={fieldData.surname} onChange={handleChange}/>
            </label>
            <label id='country-field'>
                Country:
                <input id='country-input' type="text" name="country" value={fieldData.country} onChange={handleChange}/>
            </label>
        </form>
    </div>

    
  )
}

export default Fields