class UserMailer < Devise::Mailer
  include Devise::Mailers::Helpers  

  default from: GeventAnalysis::Application::CONSTS[:contact_email]

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.expire_email.subject
  #
  # def expire_email(user)
  #   mail(:to => user.email, subject: "Subscription Cancelled")
  # end
  
  # def confirmation_email(user)
  #   mail(:to => user.email, subject: "Created new account")
  # end

  # Mailer actions
  #----------------------------------------------------------------------
  # Sends email for app user invitation
  def invited_app_user(user)
    @user     = user
    @subject = "Invitation to Bunch"
    @body = "Bunch is a simple web dashboard that integrates with your teams’ calendars."    
    mail(to: @user.email, subject: @subject)
  end

  # Sends email for having user to connect gmail
  def link_gmail_note(user)
    @user = user
    @subject = "Link Your Gmail to Bunch App"
    mail(to: @user.email, subject: @subject)
  end

  # Sends an email with analysis results of the next week events
  def weekly_analysis_report(user, analysis_results)
    @user = user
    @analysis_results = analysis_results
    @subject = "Weekly Report of Analysis for Next Week Events"
    mail(to: @user.email, subject: @subject)
  end

  def confirmation_instructions(record, token, opts={})
    headers["template_path"] = "user_mailer"
    headers["template_name"] = "confirmation_instructions"
    headers({'X-No-Spam' => 'True', 'In-Reply-To' => GeventAnalysis::Application::CONSTS[:contact_email]})
    headers['X-MC-Track'] = "False, False"

    @subject = "Invitation to Bunch"
    @body = "Bunch is a simple web dashboard that integrates with your teams’ calendars.<br />"\
            "To start using the app, please click the link below to set up your #{GeventAnalysis::Application::CONSTS[:app_name]} account "\
            "and link your gmail:"

    opts = {subject: @subject}
    super
  end

  # Send email for password reset
  def reset_password_instructions(record, token, opts={})
    headers["template_path"] = "user_mailer"
    headers["template_name"] = "reset_password_instructions"
    headers({'X-No-Spam' => 'True', 'In-Reply-To' => GeventAnalysis::Application::CONSTS[:contact_email]})
    headers['X-MC-Track'] = "False, False"
    super
  end

  # Private methods
  #----------------------------------------------------------------------
  private

  # Returns base URL according to environment
  def baseURL
    Rails.env.development? ? GeventAnalysis::Application::CONSTS[:dev_host] : GeventAnalysis::Application::CONSTS[:app_host]
  end

end