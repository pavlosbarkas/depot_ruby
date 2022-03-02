class FailureMailer < ApplicationMailer
  default from: 'System Failure <systemfailure@depot.com>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.failure_mailer.failure_occured.subject
  #
  def failure_occured
    #here we could get the admin's email

    mail to: 'admin@admin.com', subject: 'System Failure Occurred'
  end
end
