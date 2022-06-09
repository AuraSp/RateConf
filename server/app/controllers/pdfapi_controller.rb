require "RMagick"
require "chilkat"

class PdfapiController < ApplicationController

  # #http://localhost:3000/pdf/index?pdfBase64="your base64 here"?company="company name here"
  def index
    begin
      #decode pdf from base64
      pdfData = PdfService.new.decodePdfFromB64(params[:pdfBase64])
      #send pdf to s3 database and receive file name
        #coming soon
      #request s3 to analyze the file
        #coming soon
      #extract useful information
      extractedData = ExtractorService.new.extractData(params[:company])

      render json: { status: "SUCCESS", data: extractedData }, status: :ok
    rescue Exception => ex
      render json: { status: "FAILURE", data: ex.backtrace }, status: 500
    ensure

    end
  end
end
