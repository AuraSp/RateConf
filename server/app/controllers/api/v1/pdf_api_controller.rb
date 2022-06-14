require "RMagick"
require "chilkat"
require "securerandom"

class Api::V1::PdfApiController < ApplicationController
  # #http://localhost:3000/pdf_api/
  def create
    begin
      queryUUID = SecureRandom.uuid
      @query = Query.new(id: queryUUID, query_id: queryUUID, status: "started")
      @query.save

      #separate pdf analysis into separate thread
      Thread.new do
        PdfQueryService.new.startNewPdfAnalysis(@query.id, params[:pdfBase64], params[:company])
      end
      #return query ID
      render json: { query_id: queryUUID }, status: :ok
    rescue Exception => ex
      render json: { status: "FAILURE", error: ex, errorTrace: ex.backtrace }, status: 500
    ensure
    end
  end

  def index
    begin
      #render json: { query: params[:id]}, status: :ok
      render json: { query: Query.where(query_id: params[:id]), data: Audit.all }, status: :ok
    rescue Exception => ex
      render json: { status: "FAILURE", error: ex, errorTrace: ex.backtrace }, status: 500
    ensure
    end
  end
end
