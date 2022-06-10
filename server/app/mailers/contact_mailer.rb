class ContactMailer < ApplicationMailer

  def pdf_null(error_message)
    @error_message = error_message

    mail(to: Rails.application.credentials.config.dig(:admin_email), subject: "Pdf=null")
  end

  def pdfInDB_null(error_message)
    @error_message = error_message

    mail(to: Rails.application.credentials.config.dig(:admin_email), subject: "PdfInDB=-1")
  end

  def analyzedData_null(error_message)
    @error_message = error_message

    mail(to: Rails.application.credentials.config.dig(:admin_email), subject: "AnalyzedData=null")
  end
end
