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
    day = Integer(params[:date][:day]) - 1
    year = params[:date][:year]
    hour = params[:date][:hour]
    minute = params[:date][:minute]
    @checkin.time = "#{month}/#{day}/#{year} #{hour}:#{minute}"
    
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
  
  def update
    @checkin = Checkin.find(params[:id])
    month = params[:date][:month]
    day = Integer(params[:date][:day])- 1
    year = params[:date][:year]
    hour = params[:date][:hour]
    minute = params[:date][:minute]
    @checkin.time = "#{month}/#{day}/#{year} #{hour}:#{minute}"
  
    if @checkin.update_attributes(params[:checkin])
      redirect_to @checkin, :notice => 'Successfully updated!'  
    else
      render :action => "edit" 
    end
  end
  
  def destroy
    @checkin = Checkin.find(params[:id])
    unschedule_checkin(@checkin)
    @checkin.destroy
    redirect_to checkins_url
  end
end
