import axios from 'axios';

const UploadFile = () => {

  return (
    <div className='upload-file'>
        <h3>Upload File</h3>
        <div >
            <input type="file" id='file'/>
        </div>
    </div>
  )
}

export default UploadFile