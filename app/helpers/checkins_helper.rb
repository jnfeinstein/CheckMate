module CheckinsHelper
  
  require 'net/http'
  require 'uri'
  
  @@PROTOCOL = "http://"
  @@HOST = "www.southwest.com"
  @@URL_RETRIEVE = "/flight/retrieveCheckinDoc.html"
  
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
    puts res
  end
end
