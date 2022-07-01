import React from 'react'

const RateDelivery = ({ response }) => {
    let rateData = response.rate_conf_data.split(',');

    let pu = []
    let companyName = []
    let address = []
    let phone = []
    let customerTimeFrom = []
    let customerTimeTo = []

    let dataIndex = 18;

    const stops = () => {
        pu.push(rateData[dataIndex]);
        companyName.push(rateData[dataIndex + 1]);
        address.push(rateData[dataIndex + 2]);
        phone.push(rateData[dataIndex + 3]);
        customerTimeFrom.push(rateData[dataIndex + 4]);
        customerTimeTo.push(rateData[dataIndex + 5]);

        while (rateData[dataIndex + 7]) {
            dataIndex += 7;
            pu.push(rateData[dataIndex]);
            companyName.push(rateData[dataIndex + 1]);
            address.push(rateData[dataIndex + 2]);
            phone.push(rateData[dataIndex + 3]);
            customerTimeFrom.push(rateData[dataIndex + 4]);
            customerTimeTo.push(rateData[dataIndex + 5]);
        }

        let renderData = [];
        for(let i = 0; i < pu.length; i++) {
            renderData.push(
                <ul className='list'>
                    <li>{pu[i]}</li>
                    <li>{companyName[i]}</li>
                    <li>{address[i]}</li>
                    <li>{phone[i]}</li>
                    <li>{customerTimeFrom[i]}</li>
                    <li>{customerTimeTo[i]}</li>
                </ul>
            )
        }

        return (
            <div>
                {renderData.map((item) => <div><h4>Rates Stop Data(Delivery):</h4>{item}</div>)}
            </div>
        )
    }
   
    return (
        <>
            <div>
                {stops()};
            </div>
        </>
    )
}

export default RateDelivery