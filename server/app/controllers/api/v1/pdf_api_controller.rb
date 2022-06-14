require "RMagick"
require "chilkat"
require 'securerandom'

class Api::V1::PdfApiController < ApplicationController
    # #http://localhost:3000/pdf_api/
    def create
      begin
        queryUUID = SecureRandom.uuid
        @query = Query.new(queryId:queryUUID, status:"started")
        @query.save

        #separate pdf analysis into separate thread
        Thread.new do
          PdfQueryService.new.startNewPdfAnalysis(@query.id, params[:pdfBase64], params[:company])
        end
        #return query ID
        render json: { queryUUID: queryUUID}, status: :ok
      rescue Exception => ex
        render json: { status: "FAILURE", error: ex, errorTrace: ex.backtrace }, status: 500
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
  
