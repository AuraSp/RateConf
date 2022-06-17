# stebejimui
class Api::V1::QueriesController < ApplicationController
  def index
    @query = Query.all
    render json: @query, include: [:audit => { :include => [:logs] }]
  end

  def create
    @query = query.new()
  end

  private

  def set_post
    @query = Query.find(params[:id])
  end

  def query_params
    params.require(:query).permit(:body)
  end
end
