require "aws-sdk"

class TextractorJobService
  def run(jobID, company)
    textract = Aws::Textract::Client.new(
      access_key_id: Rails.application.credentials.aws.access_key_id,
      secret_access_key: Rails.application.credentials.aws.secret_access_key,
      region: Rails.application.credentials.aws.region,
    )

    response = textract.get_document_analysis({
      job_id: jobID,
    })

    if response.job_status == "SUCCEEDED"
      return ExtractorService.new.extractData(company, response.blocks)
      Audit.last.logs.create(text: "Extraction was successfull")
    end

    if response.job_status == "IN_PROGRESS"
      puts "Try again later, document analysis is still going"
      Audit.last.logs.create(text: "Extraction is in progress")
      exit
    end

    if response.job_status == "FAILED"
      puts "Document analysis failed"
      Audit.last.logs.create(text: "extraction failed")
      exit
    end

    if response.job_status == "PARTIAL_SUCCESS"
      puts "Something went wrong, try again"
      Audit.last.logs.create(text: "extraction failed on progress")
      exit
    end
  end
end
