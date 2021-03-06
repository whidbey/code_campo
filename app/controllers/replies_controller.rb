class RepliesController < ApplicationController
  before_filter :require_logined
  before_filter :find_topic, :only => [:new, :create]

  def new
    @reply = current_user.replies.new :topic => @topic
  end

  def create
    @reply = current_user.replies.new params[:reply]
    @reply.topic = @topic
    respond_to do |format|
      if @reply.save
        format.html { redirect_to topic_url(@topic, :page => @topic.last_page) }
        format.js { render :layout => false }
      else
        format.html { render :new }
        format.js { render :layout => false }
      end
    end
  end

  def edit
    @reply = current_user.replies.number params[:id]
    @return_to = request.referrer
  end

  def update
    @reply = current_user.replies.number params[:id]
    @return_to = params[:return_to]
    if @reply.update_attributes params[:reply]
      redirect_to @return_to.present? ? "#{@return_to}##{@reply.anchor}" : topic_path(@reply.topic, :anchor => @reply.anchor)
    else
      render :edit
    end
  end

  protected

  def find_topic
    @topic = Topic.number params[:topic_id]
  end
end
