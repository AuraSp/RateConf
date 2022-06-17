require "RMagick"
require "chilkat"
require "securerandom"

class Api::V1::PdfApiController < ApplicationController
  # #http://localhost:3000/pdf_api/
  protect_from_forgery with: :null_session

  def create
    begin
      queryUUID = SecureRandom.uuid
      @query = Query.new(query_id: queryUUID, status: "started")
      @query.save
      # @audit = Query.last
      @audit = @query.build_audit(process_status: "Start")
      @audit.save

      #separate pdf analysis into separate thread

      #Thread.new do
      #  PdfQueryService.new.startNewPdfAnalysis(@query.id, params[:pdfBase64], params[:company])
      #end

      AnalyzePdfJob.perform_later(@query.id, params[:pdfBase64], params[:company])

      #return query ID
      render json: { queryUUID: queryUUID }, status: :ok
      Audit.last.logs.create(text: "QueryId response true")
    rescue Exception => ex
      render json: { status: "FAILURE", error: ex, errorTrace: ex.backtrace }, status: 500
      @audit.build_audit.update(process_status: "Process failed")
      Audit.last.logs.create(text: "QueryId response failed")
    ensure
    end
  end

  def index
    begin
      render json: { query: Query.where(query_id: params[:id]) }, status: :ok
      ContactMailer.analyzedData().deliver_later
    rescue Exception => ex
      render json: { status: "FAILURE", error: ex, errorTrace: ex.backtrace }, status: 500
      ContactMailer.analyzedData_null().deliver_later
    ensure
    end
  end
end
