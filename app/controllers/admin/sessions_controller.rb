# This controller handles the login/logout function of the site.  
class Admin::SessionsController < Admin::BaseController

  skip_before_filter :login_required

  # render new.rhtml
  def new
  end

  def create
    logout_keeping_session!
    person = Admin.authenticate(params[:email], params[:password])
    if person
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = person
      new_cookie_flag = (params[:remember_me] == "1")
      handle_remember_cookie! new_cookie_flag
#      redirect_back_or_default('/')            
      redirect_to(:controller => 'dashboard')
      flash[:notice] = I18n.t("log.in.success").capitalize
    else
      note_failed_signin
      @login       = params[:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = I18n.t("log.out.success").capitalize
#    redirect_back_or_default('/')
    redirect_to(:action => 'new')
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:error] = I18n.t("log.in.failed").capitalize + " " + params[:email]
    logger.warn I18n.t("log.in.failed_message").capitalize + " " + params[:email] + " " + I18n.t("from") + " " +request.remote_ip + " " + I18n.t("at") + " " + Time.now.utc.to_s
  end
end
