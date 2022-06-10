import React from 'react'
import Autofill from './Autofill'

const Fields = ( props ) => {
  return (
    <div>

        <form>
            <label id='name-field'>
                Name:
                <input id='name-input' type="text" name="name" value={props.data.name}/>
            </label>
            <label id='surname-field'>
                Surname:
                <input id='surname-input' type="text" name="surname" value={props.data.surname}/>
            </label>
            <label id='country-field'>
                Country:
                <input id='country-input' type="text" name="country" value={props.data.country}/>
            </label>
        </form>
    </div>

    
  )
}

export default Fields