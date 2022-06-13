require "aws-sdk"

class TextractorJobService
    def run(company, jobID)
        textract = Aws::Textract::Client.new(
                access_key_id: Rails.application.credentials.aws.access_key_id,
                secret_access_key: Rails.application.credentials.aws.secret_access_key,
                region: Rails.application.credentials.aws.region
            )


        response = textract.get_document_analysis({
            job_id: jobID,
        })

        if response.job_status == "SUCCEEDED"
            ExtractorService.new.extractData(company, response.blocks)
        end

        if response.job_status == "IN_PROGRESS"
            puts "Try again later, document analysis is still going"
            exit
        end

        if response.job_status == "FAILED"
            puts "Document analysis failed"
            exit
        end

        if response.job_status == "PARTIAL_SUCCESS"
            puts "Something went wrong, try again"
            exit
        end

    end
end