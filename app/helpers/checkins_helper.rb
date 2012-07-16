module CheckinsHelper
  
  require 'net/http'
  require 'uri'
  
  @@PROTOCOL = "http://"
  @@HOST = "www.southwest.com"
  @@URL_RETRIEVE = "/flight/retrieveCheckinDoc.html"
  
  def do_checkin(checkin)
    url = URI.parse("#{@@PROTCOL}#{@@HOST}#{@@URL_RETRIEVE}")
    res = Net::HTTP.post_form(url,{
      "formToken" => "",
      "confirmationNumber" => checkin.conf,
      "firstName" => checkin.first,
      "lastName" => checkin.last,
      "submitButton" => "Check+In"})     
    if !(res.kindof? Net::HTTPRedirection)
      return
    end
    next_url = res['location']
    url = URI.parse("#{@@PROTOCOL}#{@@HOST}#{next_url}")
    res = Net::HTTP.post_form(url,{
      "formToken" => "",
      "checkinPassengers.selected" => "true",
      "printDocuments" => "Check+In"})
    if !(res.kindof? Net::HTTPRedirection)
      return
    end
    next_url = res['location']
    url = URI.parse("#{@@PROTOCOL}#{@@HOST}#{next_url}")
    res = Net::HTTP.get_response(url)
    if !(res.kind_of? Net::HTTPSuccess)
      return
    end
  end
end
