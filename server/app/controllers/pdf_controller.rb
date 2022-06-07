class PdfController <ApplicationController
    def index
        render json:{status: 'SUCCESS', message:'Loaded', data:params[:pdfBinary]},status: :ok
    end
end