require "RMagick"
require "chilkat"
require 'securerandom'

class PdfApiController < ApplicationController
  # #http://localhost:3000/pdf_api/
  def create
    begin

      #request s3 to analyze the file
      #uploadData = S3Service.new.run(params[:pdfBase64])
      #extract useful information

      #receive jobID to access textract service data
      #jobID = JobIdGenerateService.new.awsTextract(uploadData)
      #puts jobID
      #extractedData = ExtractorService.new.extractData(params[:company], uploadData)


      #render json: { status: "SUCCESS", jobid: jobID }, status: :ok

      queryUUID = SecureRandom.uuid
      @query = Query.new(queryId:queryUUID, status:"started")
      @query.save

      render json: { queryUUID: queryUUID}, status: :ok

      PdfQueryService.new.startNewPdfAnalysis(@query.id, params[:pdfBase64])

    rescue Exception => ex
      render json: { status: "FAILURE", jobid: ex }, status: 500
    ensure

    end
  end

  def index
    begin
      #render json: { query: params[:id]}, status: :ok
      render json: { query: Query.where(queryId: params[:id])}, status: :ok
    rescue Exception => ex
      render json: { status: "FAILURE", error: ex, errorTrace: ex.backtrace }, status: 500
    ensure
    end
  end
end
