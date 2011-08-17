class NewslettersController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:create]
  def create
    if Newsletter.find_or_create_by_email(params[:newsletter])
      flash[:notice] = t('newsletter.subscribe.success')
    else
      flash[:error] = t('newsletter.subscribe.failed')
    end
    redirect_to :back
  end
end
