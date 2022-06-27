require "test_helper"

class PdfApiTest < ActiveSupport::TestCase
  test "pdf path should be correct" do
    path = PdfService.new.decodePdfFromB64("gg", "test")
    assert path == "/tmp/test.pdf"
    File.delete("/tmp/test.pdf")
  end
end
