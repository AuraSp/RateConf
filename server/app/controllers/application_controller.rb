class ApplicationController < ActionController::Base
  TOKEN = "Test"

  before_action :authenticate
  protect_from_forgery with: :null_session

  private

  def authenticate
    begin
      authenticate_or_request_with_http_token do |token, options|
        ActiveSupport::SecurityUtils.secure_compare(token, TOKEN)
      end
    rescue UnauthorizedError => deny_access
    end
  end

  protected

  def deny_access() # need userid  params[:userId]
    render json: { status: 403, message: '403 FORBIDDEN\r\clientRequestId: #{userid}', source: request.original_url }
  end

  # for query pagination (check queries_controller)
  private

  def page
    @page ||= params[:page] || 1
  end

  def per_page
    @per_page ||= params[:per_page] || 11
  end

  def set_pagination_headers(p)
    headers["X-Total-Count"] = p.total_count
    # inherit from set amount per page
    headers["X-Total-Page"] = p.total_pages

    links = []
    links << page_link(1) unless p.first_page?
    links << page_link(p.prev_page) if p.prev_page
    links << page_link(p.next_page) if p.next_page
    links << page_link(p.total_pages) unless p.last_page?
    headers["Link"] = links.join(",") if links.present?
  end

  def page_link(page)
    base_uri = request.url.split("?").first
    "<#{base_uri}?#{request.query_parameters.merge(page: page).to_param}>"
  end
end
