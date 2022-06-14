require "aws-sdk"
require "RMagick"
require "chilkat"

class PdfService
  def decodePdfFromB64(b64)
    pdfData = Chilkat::CkBinData.new()
    pdfData.AppendEncoded(b64, "base64")
    #success = pdfData.WriteFile("/home/rytis/Documents/GitHub/rateconfocr/server/app/controllers/testConverted.pdf")
    return pdfData
  end

  def encodePdfToB64(path)
    pdfData = Chilkat::CkBinData.new()
    success = pdfData.LoadFile(path)
    if (success != true)
      # print "failed to load PDF file." + "\n"
      # Audit.new({ :File_id => "1", :Process_status => false })
      # Audit.save!
      raise ScriptError
      exit
    end
    # Audit.create({ :File_id => "1", :Process_status => true })
    # Audit.save!
    return pdfData.getEncoded("base64")
  end

  # Convert converted pdf into image for future slicing based on extracted data
  def convertPdfToImage
    image = Magick::Image::from_blob(convertedPdf) do
      self.format = "PDF"
      self.quality = 100
      self.density = 160
    end
    image[0].format = "JPG"
    image[0].to_blob
    return image[0]
  end
end
