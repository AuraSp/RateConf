import React from 'react';

const QueryCard = ({ response }) => {
    return (
        <ul className='list' key={response.id}>
            <li>Id: {response.id}</li>
            <li>Query_id: {response.query_id}</li>
            <li>Error data: {response.error_data}</li>
            <li>Aws s3: {response.aws_s3_name}</li>
            <li>Status:{response.status}</li>
            <li>Enquirer: {response.enquirer}</li>
            <li>Created at: {response.created_at}</li>
        </ul>
    )
}

export default QueryCard