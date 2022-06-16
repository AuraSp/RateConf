class Api::V1::TextractorJobController < ApplicationController
    def create
        company = params[:company]
        rateConfData = TextractorJobService.new.run(params[:jobID], company)

        render json: {status: "SUCCESS", Extracted: rateConfData}, status: :ok
        # newAudit = Audit.create(:File_id => params[:company], :Process_status => true)
    rescue Exception => ex
        render json: {status: "FAILURE", Extracted: "Unable to receive extracted data"}, status: 500
    ensure

    end
end