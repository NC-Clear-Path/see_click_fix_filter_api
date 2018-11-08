class FiltersController < ApplicationController
    
  def index
    # ideally this will use the latitude and longitude of the users current location, but temporarily it is showing issues for Raleigh
    all_issues = {issues: (Filter.get_json(Filter.filter_url))["issues"]}
    json_response(all_issues) # this returns 100 SeeClickFix issues for those coordinates
  end
    
  def location
    # it accepts params for latitude and longitude but has defaults for when neither is provided
    # right now I have hard coded the defaults but in the future I want them to be based on the location the request came from
    lat = params[:lat] unless params[:lat].nil?
    lat = 35.77766295 unless lat
    lng = params[:lng] unless params[:lng].nil?
    lng = -78.63974665 unless lng
    @json = Filter.get_json(Filter.filter_url(lat, lng))
    @issues = Filter.add_issues(@json)
    json_response(@issues) 
  end
  
end
