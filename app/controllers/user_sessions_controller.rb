class UserSessionsController < ApplicationController
  no_tweetbacks!

  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    @user_session = UserSession.new(params[:user_session])
    @user_session.save do |result|
      if result
        flash[:notice] = 'Successfully logged in.'
        redirect_to root_url
      else
        render :action => "new"
      end
    end
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    @user_session = UserSession.find(params[:id])
    @user_session.destroy if @user_session

    flash[:notice] = 'Successfully logged out.'
    redirect_to root_url
  end
end
