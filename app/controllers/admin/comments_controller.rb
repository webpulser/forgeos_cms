class Admin::CommentsController < Admin::BaseController
  
  before_filter :find_commentable
  before_filter :get_comment, :only => [:show, :edit, :update, :destroy]
  before_filter :new_comment, :only => [:new, :create]

  def index
    @comments = @commentable.comments.all
  end
  
  def show
  end
  
  def new
  end
  
  def edit
  end
  
  def create
    if @comment.save
      flash[:notice] = I18n.t('comment.create.success').capitalize
      return redirect_to([:admin, @commentable])
    else
      flash[:error] = I18n.t('comment.create.failed').capitalize
      render :action => "new"
    end
  end

  def update
    if @comment.update_attributes(params[:comment])
      flash[:notice] = I18n.t('comment.update.success').capitalize
      return redirect_to([:admin, @commentable])
    else
      flash[:error] = I18n.t('comment.update.failed').capitalize
      render :action => "edit"
    end
  end

  def destroy
    if @comment.destroy
      flash[:notice] = I18n.t('comment.destroy.success').capitalize
    else
      flash[:error] = I18n.t('comment.destroy.failed').capitalize
    end
    return redirect_to([:admin, @commentable])
  end
  
private

  def get_comment
    unless @comment = @commentable.comments.find_by_id(params[:id])
      flash[:error] = I18n.t('comment.not_exist').capitalize
      return redirect_to admin_comments_path
    end
  end

  def new_comment
    @comment = @commentable.comments.new(params[:comment])
  end

  def find_commentable
    unless @commentable = Actuality.find_by_id(params[:actuality_id])
      flash[:error] = I18n.t('actuality.not_exist').capitalize
      return redirect_to admin_actualities_path
    end
  end
end