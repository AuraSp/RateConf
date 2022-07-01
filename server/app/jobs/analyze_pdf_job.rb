class AnalyzePdfJob < ApplicationJob
  queue_as :default

  def perform(queryUUID, base64Pdf, company)
    begin
      @query = Query.find(queryUUID)
      @query.update(status: "processing")
      #create query audit logging
      @audit = @query.build_audit()
      @audit.save

      @audit.logs.create(text: "start processing")

      #decode requested pdf file
      @audit.logs.create(text: "Decoding uploaded pdf file")
      tempPath = PdfService.new.decodePdfFromB64(base64Pdf, @query.query_id)
      
      if !tempPath
        @audit.logs.create(text: "decoding uploaded pdf file failed")
        raise StandardError.new "Decoding file Error"
      else
        @audit.logs.create(text: "Pdf file decoded")
      end

      #upload pdf to S3
      @audit.logs.create(text: "uploading to aws")
      uploadData = AwsService.new.uploadToS3(tempPath, @query.query_id)
      @query.update(aws_s3_name: uploadData)

      if !uploadData
        @audit.logs.create(text: "upload to bucket failed")
        raise StandardError.new "Upload to bucket Error"
      else
        @audit.logs.create(text: "uploaded to bucket successfully")
      end

      #receive jobID to access textract service data
      @audit.logs.create(text: "getting jobId to access textract service")
      jobID = AwsService.new.awsTextract(uploadData)
      if !jobID
        @audit.logs.create(text: "getting jobID failed")
        raise StandardError.new "JobID Error"
      else
        @audit.logs.create(text: "access textract service data successfully")
      end

      #start AWS text extraction
      @audit.logs.create(text: "starting AWS text extraction")
      textract = Aws::Textract::Client.new(
        access_key_id: Rails.application.credentials.aws.access_key_id,
        secret_access_key: Rails.application.credentials.aws.secret_access_key,
        region: Rails.application.credentials.aws.region,
      )
      response = textract.get_document_analysis({
        job_id: jobID,
      })

      #Wait for Textract API response
      @audit.logs.create(text: "waiting for AWS Textract API")
      while true
        response = textract.get_document_analysis({
          job_id: jobID,
        })

        if response.job_status == "SUCCEEDED"
          @audit.logs.create(text: "AWS Textract API response received successfully")
          break
        end
        if response.job_status == "FAILED"
          @audit.logs.create(text: "AWS Textract API failed")
          raise StandardError.new "AWS Textract Error"
          break
        end
        sleep(2)
      end

      if response.job_status == "SUCCEEDED"
        @audit.logs.create(text: "extracting fields from AWS data")
        extractedData = ExtractorService.new.extractData(company, response.blocks)
        @audit.logs.create(text: "extracted data successfully")

        #finalize success response
        @lastlog = @query.audit.logs.last
        @query.update(status: "finished", rate_conf_data: extractedData, error_data: @lastlog.text)
        @query.save
        ContactMailer.analyzedData(@audit).deliver_later
      end
    rescue Exception => e
      #finalize failure response
      @audit.logs.create(text: ("extract data failed!" + "Exception Occurred #{e.class}. Message: #{e.message}. \n Backtrace:  \n #{e.backtrace.join("\n")}"))
      @lastlog = @query.audit.logs.last
      @query.update(status: "failed", rate_conf_data: nil, error_data: @lastlog.text)
      @query.save
      ContactMailer.analyzedData_null(@audit).deliver_later
    end
  end
end
