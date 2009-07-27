class Admin::AccountController < Admin::BaseController

  # GET /account
  # GET /account.xml
  def index
    return redirect_to(admin_account_path(self.current_user))
  end

  # GET /account/1
  # GET /account/1.xml
  def show
    @user = self.current_user
  end

  # GET /account/1/edit
  def edit
    @user = self.current_user
  end

  # PUT /account/1
  # PUT /account/1.xml
  def update
    @user = self.current_user
    upload_avatar 
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = I18n.t('my_account.update.success').capitalize
        format.html { redirect_to(admin_account_path(@user)) }
        format.xml  { head :ok }
      else
        flash[:error] = I18n.t('my_account.update.failed').capitalize
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /account/1
  # DELETE /account/1.xml
  def destroy
    @user = self.current_user
    logout_killing_session!
    if @user && @user.destroy
      flash[:notice] = I18n.t('my_account.destroy.success').capitalize
    else
      flash[:error] = I18n.t('my_account.destroy.success').capitalize
    end

    respond_to do |format|
      format.html { redirect_to(new_admin_session_path) }
      format.xml  { head :ok }
    end
  end

private

  def upload_avatar
    if @user && params[:avatar] && params[:avatar][:uploaded_data] && !params[:avatar][:uploaded_data].blank?
      @avatar = @user.create_avatar(params[:avatar])
      flash[:error] = @avatar.errors unless @avatar.save
      params[:user].update(:avatar_id => @avatar.id)
    end
  end
end
