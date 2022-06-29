class AnalyzePdfJob < ApplicationJob
  queue_as :default

  def perform(queryUUID, base64Pdf, company)
    @query = Query.find(queryUUID)
    @query.update(status: "processing")

    @audit = @query.build_audit()
    @audit.save

    @audit.logs.create(text: "start processing")

    #decode uploaded pdf file
    tempPath = PdfService.new.decodePdfFromB64(base64Pdf, @query.query_id)
    @audit.logs.create(text: "decoding uploaded pdf file")
    Audit.first.logs.create(text: "decoding pdf from B64")

    #request s3 to analyze the file
    uploadData = AwsService.new.uploadToS3(tempPath, @query.query_id)
    @audit.logs.create(text: "requesting for analyzing the file")
    @query.update(aws_s3_name: uploadData)

    #receive jobID to access textract service data
    @audit.logs.create(text: "getting jobId to access textract service")
    jobID = AwsService.new.awsTextract(uploadData)

    #start AWS text extraction
    textract = Aws::Textract::Client.new(
      access_key_id: Rails.application.credentials.aws.access_key_id,
      secret_access_key: Rails.application.credentials.aws.secret_access_key,
      region: Rails.application.credentials.aws.region,
    )

    response = textract.get_document_analysis({
      job_id: jobID,
    })

    @audit.logs.create(text: "waiting for AWS Textract API")

    while true
      response = textract.get_document_analysis({
        job_id: jobID,
      })

      if response.job_status == "SUCCEEDED"
        @audit.logs.create(text: "AWS Textract API received successfully")

        begin
          print response.blocks.to_json
          extractedData = ExtractorService.new.extractData(company, response.blocks)
          @audit.logs.create(text: "extracted data taken successfully")
          @lastlog = @query.audit.logs.last
          @query.update(status: "finished", rate_conf_data: extractedData, error_data: @lastlog.text)
        rescue Exception => e
          @audit.logs.create(text: ("extract data failed" + e.backtrace.inspect))
          @lastlog = @query.audit.logs.last
          @query.update(status: "failed", rate_conf_data: nil, error_data: @lastlog.text)
        end

        @query.save
        break
      end
      if response.job_status == "FAILED"
        @audit.logs.create(text: "extracted data taking failed")
        @lastlog = @query.audit.logs.last
        @query.update(status: "failed", rate_conf_data: extractedData)
        @query.save
        break
      end
      sleep(2)
    end
  end
end
