class CheckinsController < ApplicationController
  
  include CheckinsHelper
  
  def index
    @checkins = current_user.checkins
  end
  
  def show
    @checkin = Checkin.find(params[:id])
  end
  
  def new
    @checkin = Checkin.new
  end
  
  def create
    @checkin = current_user.checkins.create(params[:checkin])
    month = params[:date][:month]
    day = params[:date][:day]
    year = params[:date][:year]
    hour = params[:date][:hour]
    minute = params[:date][:minute]
    @checkin.time = "#{month}/#{day}/#{year} #{hour}:#{minute}"
    @checkin.time_zone = params[:checkin][:time_zone]
    
    if @checkin.save
      schedule_checkin(@checkin)
      redirect_to @checkin
    else
      render :action => "new"
    end
  end
  
  def edit
    @checkin = Checkin.find(params[:id])
  end
  
  def destroy
    @checkin = Checkin.find(params[:id])
    unschedule_checkin(@checkin)
    @checkin.destroy
    redirect_to checkins_url
  end
  
  def test_email
    UserMailer.delay.test_email(current_user)
    redirect_to checkins_url
  end
end
