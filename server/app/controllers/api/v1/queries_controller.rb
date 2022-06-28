# stebejimui
class Api::V1::QueriesController < ApplicationController

  # http://localhost:5000/api/v1/queries <= LIST ALL EXISTING QUERIES || OR
  # http://localhost:5000/api/v1/queries?page=[page number] <= DEFAULT PER_PAGE = 10 QUERIES || OR
  # http://localhost:5000/api/v1/queries?per_page=[query count] <= CHOOSE QUERIES COUNT PER_PAGE || OR
  # http://localhost:5000/api/v1/queries?page=[page number]&&per_page=[query count] <= CHOOSE BOTH - WHICH PAGE, HOW MANY QUERIES PER_PAGE

  def index
    begin
      @query = Query.all.page(page).per(per_page)
      render json: @query, include: [:audit => { :include => [:logs] }]

      # from application_controller
      set_pagination_headers(@query)
    rescue Exception => invalid
      render json: { status: "Failed", message: "Index is invalid", report: invalid.backtrace }, status: 404.1
    end
  end

  private

  def set_post
    @query = Query.find(params[:id])
  end

  def query_params
    params.require(:query).permit(:body)
  end
end
