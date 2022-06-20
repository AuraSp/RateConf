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

      #separate pdf analysis into separate job
      AnalyzePdfJob.perform_later(@query.id, params[:pdfBase64], params[:company])

      #return query ID
      render json: { queryUUID: queryUUID }, status: :ok
    rescue Exception => ex
      render json: { status: "FAILURE", error: ex, errorTrace: ex.backtrace }, status: 500
    ensure
    end
  end

  def index
    begin
      render json: { query: Query.where(query_id: params[:id]) }, status: :ok
    rescue Exception => ex
      render json: { status: "FAILURE", error: ex, errorTrace: ex.backtrace }, status: 500
    ensure
    end
  end
end
