class ContactMailer < ApplicationMailer

  def error_email(error_message)
    @error_message = error_message

    mail(to: Rails.application.credentials.config.dig(:admin_email), subject: "Welcome to My Awesome Site")
  end
end
