import React from 'react'

const RatePickUp = ({ response }) => {

    let rateData = response.rate_conf_data.split(',');
    return (
        <>
            <h4>Rates Stop Data(Pick up):</h4>
            <ul className='list'>
                <li>{rateData[9]}</li>
                <li>{rateData[10]}</li>
                <li>{rateData[11]}</li>
                <li>{rateData[12]}</li>
                <li>{rateData[13]}</li>
                <li>{rateData[14]}</li>
                <li>{rateData[15]}</li>
                <li>{rateData[16]}</li>
            </ul>
        </>
    )
}

export default RatePickUp