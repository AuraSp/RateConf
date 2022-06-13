require "RMagick"
require "chilkat"

class PdfApiController < ApplicationController

 

  # #http://localhost:3000/pdf_api/
  def create
    begin
      #request s3 to analyze the file
      uploadData = S3Service.new.run(params[:pdfBase64])
      #extract useful information

      #receive jobID to access textract service data
      jobID = JobIdGenerateService.new.awsTextract(uploadData)
      puts jobID
      #extractedData = ExtractorService.new.extractData(params[:company], uploadData)


      render json: { status: "SUCCESS", data: extractedData }, status: :ok
    rescue Exception => ex
      render json: { status: "FAILURE", data: ex }, status: 500
    ensure

    end
  end
end
