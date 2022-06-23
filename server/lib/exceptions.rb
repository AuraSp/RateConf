module Exceptions
  class FileNotFound < StandardError; end
  class FileNotUploaded < StandartError; end
  class ImageConvertingError < StandartError; end
  class PdfServiceError < StandardError; end
  class AwsTextractorResponse < StandartError; end
  class KeyTableDataExtraction < StandardError; end
  class AwsS3ClientServiceError < StandardError; end
  class AwsTextractorServiceError < StandardError; end
end
