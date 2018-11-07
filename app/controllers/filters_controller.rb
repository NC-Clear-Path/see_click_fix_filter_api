class FiltersController < ApplicationController
    
  def index
    # ideally this will use the latitude and longitude of the users current location, but temporarily it is showing issues for all locations
    json_response(Filter.show_issues) # this returns all the SeeClickFix issues for those coordinates
  end
    
  def location
    # I am limiting the location to Raleigh, but I will permit params for latitude and longitude once I get the data better filtered
    # so it doesn't take so long to load
    json_response(Filter.show_location_issues) # this returns all the SeeClickFix issues for those coordinates
  end
  
end
