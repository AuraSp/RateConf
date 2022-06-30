require "aws-sdk"
require "rmagick"
require "chilkat"

class PdfService
  begin
    def decodePdfFromB64(b64, queryId)
      tempFilePath = "/tmp/#{queryId}.pdf"
      File.open(tempFilePath, "wb") do |f|
        f.write(Base64.decode64(b64))
      rescue LoadError => ex
      end

      return tempFilePath
    end

    def encodePdfToB64(path)
      begin
        if (!File.file?(path))
          print "failed to load PDF file."
          exitF
        end

        file = open(path)
        b64 = Base64.encode64(file.read)
        return b64
      rescue Encoding::InvalidByteSequenceError => ex
      end
    end

    def deleteTempPdf(path)
      File.delete(path) if File.exist?(path)
    end

    # Convert converted pdf into image for future slicing based on extracted data
    def convertPdfToImage
      image = Magick::Image::from_blob(convertedPdf) do
        self.format = "PDF"
        self.quality = 100
        self.density = 160
      rescue Custom::ImageConvertingError => ex
      end
      image[0].format = "JPG"
      image[0].to_blob
      return image[0]
    end
  rescue Custom::PdfService => ex
  end
end
