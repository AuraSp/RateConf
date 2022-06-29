import React from 'react'

const List = ({ response }) => {
  let rateData = response.rate_conf_data.split(',');
  return (
    <pre>{rateData}</pre>
  )
}

export default List