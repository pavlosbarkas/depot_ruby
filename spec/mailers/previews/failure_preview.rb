# Preview all emails at http://localhost:3000/rails/mailers/failure
class FailurePreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/failure/failure_occured
  def failure_occured
    FailureMailer.failure_occured
  end

end
