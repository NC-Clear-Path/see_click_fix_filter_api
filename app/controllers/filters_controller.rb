class FiltersController < ApplicationController
    before_action :show_issues, only: [:index]
    before_action :show_location_issues, only: [:location]
  def index
    # ideally this will use the latitude and longitude of the users current location, but temporarily it is showing issues for all locations
    json_response(@issues) # this returns all the SeeClickFix issues for those coordinates
  end
    
  def location
    # I am limiting the location to Raleigh for now but it will take coordinates in the future
    json_response(@location_issues) # this returns all the SeeClickFix issues for those coordinates
  end
  
  private
  def show_issues
    @issues = Filter.show_issues
  end
  
  def show_location_issues
    @location_issues = Filter.show_location_issues
  end
end
