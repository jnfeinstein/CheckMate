class HomeController < ApplicationController
  
  def index
    redirect_to checkins_url
  end
end
