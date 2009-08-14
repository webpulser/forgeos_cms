class Admin::CommentsController < Admin::BaseController  
  before_filter :find_commentable

  # GET /comments
  # GET /comments.xml
  def index
    @comments = @commentable.comments.find(:all)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @comments }
    end
  end
  
  # GET /comments/1
  # GET /comments/1.xml
  def show
    @comment = @commentable.comments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @comment }
    end
  end
  
  # GET /comments/new
  # GET /comments/new.xml
  def new
    @comment = @commentable.comments.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @comment }
    end
  end
  
  # GET /comments/1/new
  def edit
    @comment = @commentable.comments.find(params[:id])
  end
  
  # POST /comments
  # POST /comments.xml
  def create
    @comment = @commentable.comments.new(params[:comment])

    respond_to do |format|
      if @comment.save
        flash[:notice] = I18n.t('comment.create.success').capitalize
        format.html { redirect_to([:admin, @commentable]) }
        format.xml  { render :xml => @comment, :status => :created, :location => @comment }
      else
        flash[:error] = I18n.t('comment.create.failed').capitalize
        format.html { render :action => "new" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /comments/1
  # PUT /comments/1.xml
  def update
    @comment = @commentable.comments.find(params[:id])

    respond_to do |format|
      if @comment.update_attributes(params[:comment])
        flash[:notice] = I18n.t('comment.update.success').capitalize
        format.html { redirect_to([:admin, @commentable]) }
        format.xml  { head :ok }
      else
        flash[:error] = I18n.t('comment.update.failed').capitalize
        format.html { render :action => "edit" }
        format.xml  { render :xml => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.xml
  def destroy
    @comment = @commentable.comments.find(params[:id])
    if @comment && @comment.destroy
      flash[:notice] = I18n.t('comment.destroy.success').capitalize
    else
      flash[:error] = I18n.t('comment.destroy.failed').capitalize
    end

    respond_to do |format|
      format.html { redirect_to [:admin, @commentable] }
      format.xml  { head :ok }
    end
  end
  
private

  def find_commentable
    #FIXME : more generic
    @commentable = New.find_by_id(params[:actuality_id])
  end
end