class AnalyzePdfJob < ApplicationJob
  queue_as :default

  def perform(queryUUID, base64Pdf, company)
    @query = Query.find(queryUUID)
    @query.update(status: "processing")
    Audit.last.logs.create(text: "start processing")
    #decode uploaded pdf file
    tempPath = PdfService.new.decodePdfFromB64(base64Pdf, @query.queryId)
    Audit.last.logs.create(text: "decoding uploaded pdf file")
    #request s3 to analyze the file
    uploadData = AwsService.new.uploadToS3(tempPath, @query.id)
    Audit.last.logs.create(text: "requesting for analyzing the file")
    @query.update(aws_s3_name: uploadData)
    #receive jobID to access textract service data
    Audit.last.logs.create(text: "getting jobId to access textract service")
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
        Audit.last.logs.create(text: "extracted data taken successfully")
        @lastlog = @query.audit.logs.last
        @query.update(status: "finished", rate_conf_data: extractedData, error_data: @lastlog.text)
        @query.save
        break
      end
      if response.job_status == "FAILED"
        Audit.last.logs.create(text: "extracted data taking failed")
        @lastlog = @query.audit.logs.last
        @query.update(status: "failed", rate_conf_data: extractedData)
        @query.save
        break
      end
      sleep(2)
    end
  end
end
