require "aws-sdk"

class JobIdGenerateService
    def awsTextract(fileName)
        textract = Aws::Textract::Client.new(
          access_key_id: Rails.application.credentials.aws.access_key_id,
          secret_access_key: Rails.application.credentials.aws.secret_access_key,
          region: Rails.application.credentials.aws.region
        )
  
        requestResponse = textract.start_document_analysis({
          document_location: {
            s3_object: {
              bucket: "team3-pdfers-rateconfocr-bucket",
              name: fileName,
            },
          },
          feature_types: ["TABLES", "FORMS"]
        })
        return requestResponse.job_id
    end
end
