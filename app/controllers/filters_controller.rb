class FiltersController < ApplicationController
    before_action :next_page, only: [:location]
    # after_action :full_location_issues, only: [:next_page]
  def index
    # ideally this will use the latitude and longitude of the users current location, but temporarily it is showing issues for Raleigh
    all_issues = {issues: (Filter.get_json(Filter.filter_url))["issues"]}
    json_response(all_issues) # this returns 100 SeeClickFix issues for those coordinates
  end
    
  def location
    json_response(@issues) 
  end
  
  def full_location_issues
    json_response(@issues)
  end
  
  private
  
  def next_page
    # I am limiting the location to Raleigh for now but it will take coordinates in the future
    @json = Filter.get_json(Filter.filter_url)
    url = @json["metadata"]["pagination"]["next_page_url"]
    unless url.nil?
      # @json = Filter.get_json(url)
      @issues = Filter.add_issues(@json)
    end
    
  end 
end
