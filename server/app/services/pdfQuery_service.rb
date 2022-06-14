require 'securerandom'

class PdfQueryService

    def startNewPdfAnalysis(queryUUID, base64Pdf)

      @query = Query.find(queryUUID)
      @query.update(status:"processing")

      #request s3 to analyze the file
      #uploadData = S3Service.new.run(base64Pdf)
      #extract useful information
      extractedData = ExtractorService.new.extractData("kenco")

      @query.update(status:"finished", rateConfData: extractedData)
      @query.save
      
    end
end