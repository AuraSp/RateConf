require "RMagick"
require "chilkat"

class PdfController < ApplicationController
  before_action :authenticate

  # #http://localhost:3000/pdf/index?pdfBase64=your base64 here
  def index
    # render plain: "I'm only accessible if you know the password"
    #  pdfData = Chilkat::CkBinData.new()

    # success = pdfData.LoadFile("/home/rytis/Documents/GitHub/rateconfocr/server/app/controllers/sample.pdf")
    # if (success != true)
    #     print "failed to load PDF file." + "\n";
    #     exit
    # end

    # # Encode the PDF to base64
    # # Note: to produce base64 on multiple lines (as it would appear in the MIME of an email),
    # #  pass the string "base64_mime" instead of "base64".
    # b64 = pdfData.getEncoded("base64")

    # # print b64 + "\n";

    # # Decode from base64 PDF.
    # pdfData2 = Chilkat::CkBinData.new()
    # pdfData2.AppendEncoded(b64,"base64")
    # success = pdfData2.WriteFile("/home/rytis/Documents/GitHub/rateconfocr/server/app/controllers/converted.pdf")

    # convertedPdf = File.open('/home/rytis/Documents/GitHub/rateconfocr/server/app/controllers/converted.pdf', 'rb').read

    # # Convert converted pdf into image for future slicing based on extracted data
    # image = Magick::Image::from_blob(convertedPdf) do
    #     self.format = 'PDF'
    #     self.quality = 100
    #     self.density = 160
    #   end
    #   image[0].format = 'JPG'
    #   image[0].to_blob
    #   image[0].write('/home/rytis/Documents/GitHub/rateconfocr/server/app/controllers/to_file.jpg')

    # Send pdf to aws
    # Get data back
    # Extract data to appropriate fields based on keys

    render json: { status: "SUCCESS", message: "Loaded", data: params[:pdfBase64] }, status: :ok
  end
end
