module Custom
  class FileNotFound < ::StandardError; end
  class FileNotUploaded < StandardError; end
  class ImageConvertingError < StandardError; end
  class PdfServiceError < StandardError; end
  class AwsTextractorResponse < StandardError; end
  class KeyTableDataExtraction < StandardError; end
  class AwsS3ClientServiceError < StandardError; end
  class AwsTextractorServiceError < StandardError; end
end
