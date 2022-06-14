class Api::V1::TextractorJobController < ApplicationController

    def create
        company = params[:company]
        rateConfData = TextractorJobService.new.run(params[:jobID], company)
        render json: {Extracted: rateConfData}
    end
end