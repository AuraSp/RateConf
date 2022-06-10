require "RMagick"
require "chilkat"

class PdfapiController < ApplicationController

  # #http://localhost:3000/pdf/index?pdfBase64="your base64 here"?company="company name here"
  def index
    begin
      #request s3 to analyze the file
        #coming soon
      #extract useful information
      extractedData = ExtractorService.new.extractData(params[:company])

      render json: { status: "SUCCESS", data: extractedData }, status: :ok
    rescue Exception => ex
      render json: { status: "FAILURE", data: ex }, status: 500
    ensure

    end
  end
end
