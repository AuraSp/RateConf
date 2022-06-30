import React from 'react'

const RateDelivery = ({ response }) => {

    let rateData = response.rate_conf_data.split(',');
    return (
        <>
            <h4>Rates Stop Data(Delivery):</h4>
            <ul className='list'>
                <li>{rateData[18]}</li>
                <li>{rateData[19]}</li>
                <li>{rateData[20]}</li>
                <li>{rateData[21]}</li>
                <li>{rateData[22]}</li>
                <li>{rateData[23]}</li>
                <li>{rateData[24]}</li>
                <li>{rateData[25]}</li>
                <li>{rateData[26]}</li>
            </ul>
        </>
    )
}

export default RateDelivery