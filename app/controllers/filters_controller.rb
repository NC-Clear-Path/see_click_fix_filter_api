class FiltersController < ApplicationController
    
    def index
        # ideally this will use the latitude and longitude of the users current location, but temporarily I am supplying those details
        json_response(Filter.show_location_issues(35.787743, -78.644257)) # this returns all the SeeClickFix issues for those coordinates
    end
    
end
