#replaced by analyze_pdf_job
require "securerandom"

class PdfQueryService
  def startNewPdfAnalysis(queryUUID, base64Pdf, company)
    @query = Query.find(queryUUID)
    @query.update(status: "processing")
    #decode uploaded pdf file
    tempPath = PdfService.new.decodePdfFromB64(base64Pdf, @query.id)
    #request s3 to analyze the file
    uploadData = AwsService.new.uploadToS3(tempPath, @query.id)
    @query.update(awsS3name: uploadData)
    #receive jobID to access textract service data
    jobID = AwsService.new.awsTextract(uploadData)

    textract = Aws::Textract::Client.new(
      access_key_id: Rails.application.credentials.aws.access_key_id,
      secret_access_key: Rails.application.credentials.aws.secret_access_key,
      region: Rails.application.credentials.aws.region,
    )

    response = textract.get_document_analysis({
      job_id: jobID,
    })

    while true
      response = textract.get_document_analysis({
        job_id: jobID,
      })

      if response.job_status == "SUCCEEDED"
        extractedData = ExtractorService.new.extractData(company, response.blocks)
        @query.update(status: "finished", rate_conf_data: extractedData)
        @query.save
        break
      end
      if response.job_status == "FAILED"
        @query.update(status: "failed", rate_conf_data: extractedData)
        @query.save
        break
      end
      sleep(2)
    end
  end
end
