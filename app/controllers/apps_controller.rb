class AppsController < ApplicationController
  before_filter :user_signed_in?, only: [:create, :destroy]
  before_filter :correct_user,   only: :destroy

  def index
  end
  
  def new
    @app = App.new
  end

  def create
  	@app = current_user.apps.build(params[:app])
    if @app.save
      flash[:success] = "Application created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def show
    @app = App.find(params[:id])
    @user = @app.user
  end

  def destroy
    @app.destroy
    redirect_to root_url
  end

  private

    def correct_user
      @app = App.find_by_id(params[:id])
      redirect_to root_url unless current_user?(@app.user)
    end
end