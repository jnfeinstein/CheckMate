module CheckinsHelper
  
  require 'net/http'
  require 'uri'
  
  @@PROTOCOL = "http://"
  @@HOST = "www.southwest.com"
  @@URL_RETRIEVE = "/flight/retrieveCheckinDoc.html"
  
  @@scheduler = Rufus::Scheduler.start_new
  
  def init_scheduler
    schedule_all_checkins  
  end
  
  def do_checkin(checkin)
    url = URI.parse("#{@@PROTOCOL}#{@@HOST}#{@@URL_RETRIEVE}")
    res = Net::HTTP.post_form(url,{
      "formToken" => "",
      "confirmationNumber" => checkin.conf,
      "firstName" => checkin.first,
      "lastName" => checkin.last,
      "submitButton" => "Check In"})   
    case res
    when Net::HTTPRedirection then
    else
      puts "Step 1: Not a 302"
      return
    end
    url = URI.parse(res['location'])
    req = Net::HTTP::Post.new(url.request_uri)
    req.set_form_data({
      "formToken" => "",
      "checkinPassengers[0].selected" => "true",
      "printDocuments" => "Check In"},'&')
    res = Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
    case res
    when !Net::HTTPRedirection then 
      puts "Step 2: Not a 302"
      return
    end
    url = URI.parse(res['location'])
    res = Net::HTTP.get_response(url)
    case res
    when Net::HTTPSuccess then 
    else
      puts "Step 3: Not a 200"
      return
    end
    @checkin.destroy
  end
  
  def schedule_checkin(checkin)
    time = DateTime.parse(checkin.time)
    time = (time.to_time - 1.day).to_datetime
    Rails.logger.debug("TIME: #{time}")
    job = @@scheduler.at time do
      do_checkin(checkin)
    end
    checkin.job_id = job.job_id
    checkin.save
  end
  
  def unschedule_checkin(checkin)
    @@scheduler.unschedule(checkin.job_id)
  end
  
  def schedule_all_checkins
    if !Checkin.table_exists?
      return
    end
    Checkin.all.each do |checkin|
      schedule_checkin(checkin)
    end
  end
end
