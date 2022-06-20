# stebejimui
class Api::V1::QueriesController < ApplicationController

  # http://localhost:5000/api/v1/queries?page=[page number]&&per_page=[query count]

  def index
    @query = Query.all.page(page).per(per_page)
    render json: @query, include: [:audit => { :include => [:logs] }]

    set_pagination_headers(@query)
  end

  def create
    @query = Query.create()
  end

  private

  def set_post
    @query = Query.find(params[:id])
  end

  def query_params
    params.require(:query).permit(:body)
  end
end
