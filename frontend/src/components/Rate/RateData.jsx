import React from 'react';

const rateData = ({ response }) => {

  let rateData = response.rate_conf_data.split(',');
  return (
    <>
      <h4>Rate Sales Data:</h4>
      <ul className='list'>
        <li>{rateData[0]}</li>
        <li>{rateData[1]}</li>
        <li>{rateData[2]}</li>
        <li>{rateData[3]}</li>
        <li>{rateData[4]}</li>
        <li>{rateData[5]}</li>
        <li>{rateData[6]}</li>
        <li>{rateData[7]}</li>
        <li>{rateData[8]}</li>
      </ul>
    </>
  )
}

export default rateData