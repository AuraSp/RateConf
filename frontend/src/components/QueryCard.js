import React from 'react';

const QueryCard = ({ response }) => {
    return (
        <>
            <h4>Query Data:</h4>
            <ul className='list' key={response.id}>
                <li><span>ID: </span>{response.id}</li>
                <li><span>Query_id: </span>{response.query_id}</li>
                <li><span>Error data: </span>{response.error_data}</li>
                <li><span>Aws s3: </span>{response.aws_s3_name}</li>
                <li><span>Status: </span>{response.status}</li>
                <li><span>Enquirer: </span>{response.enquirer}</li>
                <li><span>Created at: </span>{response.created_at}</li>
            </ul>
        </>
    )
}

export default QueryCard