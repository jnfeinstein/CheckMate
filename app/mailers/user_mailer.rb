class UserMailer < ActionMailer::Base
  default :from => "checkmatesw@gmail.com"
  
  def test_email(user)
    @user = user
    @url = "http://joelf.dyndns.org"
    mail(:to => user.email, :subject => "Test email from CheckMate")
  end
end
