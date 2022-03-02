require "rails_helper"

RSpec.describe FailureMailer, type: :mailer do
  describe "failure_occured" do
    let(:mail) { FailureMailer.failure_occured }

    it "renders the headers" do
      expect(mail.subject).to eq("Failure occured")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
