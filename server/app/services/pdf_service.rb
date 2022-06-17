require "aws-sdk"
require "rmagick"
require "chilkat"

class PdfService
  def decodePdfFromB64(b64, queryId)
    tempFilePath = "/tmp/#{queryId}.pdf"
    File.open(tempFilePath, "wb") do |f|
      f.write(Base64.decode64(b64))
    end
    
    return tempFilePath
  end

  def encodePdfToB64(path)
    if (!File.file?(path))
      print "failed to load PDF file."
      exit
    end

    file = open(path)
    b64 = Base64.encode64(file.read)
    return b64
  end

  def deleteTempPdf(path)
    File.delete(path) if File.exist?(path)
  end
  
  # Convert converted pdf into image for future slicing based on extracted data
  def convertPdfToImage
    image = Magick::Image::from_blob(convertedPdf) do
      self.format = 'PDF'
      self.quality = 100
      self.density = 160
    end
    image[0].format = 'JPG'
    image[0].to_blob
    return image[0]
  end
end
