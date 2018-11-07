class Filter < ApplicationRecord
  require "open-uri"
  require "net/http"
  require "json"
  
  # the base url I used goes to the issues page of the SeeClickFix api and filters issues by their status (specifying open or acknowledged) this url is the default for all the methods
  
  # below is example of an issue reported to SeeClickFix
  # each response has metadata with the number of pages, since pagination is being used by the api
  # there there many issues returned for the query I sent the api but I just chose the first as an example
  # {
  #   "metadata":
  #     {"pagination":
  #       {"entries":523201,"page":1,"per_page":1,"pages":523201,"next_page":2,"next_page_url":"https://seeclickfix.com/api/v2/issues?lat=29.5859296&lng=-95.5525199&page=2&per_page=1&sort=distance&status=open%2Cacknowledged","previous_page":null,"previous_page_url":null
  #       }
  #     },
  #   "issues":[
  #     {"id":4822743,"status":"Acknowledged","summary":"Curb numbering designs, choice of about 50 designs","description":"Creative Curb Numbers Painting plans to paint many various chosen designs on Quail Valley curbs starting this week, doing away with standard numbering designs.  A \"Christmas-tree\" effect.\r\n\r\nThe owner is Federico Mendez, phone 832 661 3716.","rating":3,"lat":29.5859296,"lng":-95.5525199,"address":"3130 Meadowcreek Drive Missouri City, Texas","created_at":"2018-08-21T18:24:38-04:00","acknowledged_at":"2018-08-22T10:32:01-04:00","closed_at":null,"reopened_at":null,"updated_at":"2018-08-22T10:32:14-04:00","shortened_url":null,"url":"https://seeclickfix.com/api/v2/issues/4822743","point":{"type":"Point","coordinates":[-95.5525199,29.5859296]},"private_visibility":false,"html_url":"https://seeclickfix.com/issues/4822743","request_type":{"id":5763,"title":"Address","organization":"Missouri City","url":"https://seeclickfix.com/api/v2/request_types/5763","related_issues_url":"https://seeclickfix.com/api/v2/issues?lat=29.5859296&lng=-95.5525199&request_types=5763&sort=distance"},"comment_url":"https://seeclickfix.com/api/v2/issues/4822743/comments","flag_url":"https://seeclickfix.com/api/v2/issues/4822743/flag","transitions":{},"reporter":{"id":0,"name":"An anonymous SeeClickFix user","witty_title":"Street Smart","avatar":{"full":"https://seeclickfix.com/assets/anonymous-avatar-100x100-127a80e459a3fd9874ad8556fb9140ffa2f046dec0dbebe1ff67e922098c8c02.png","square_100x100":"https://seeclickfix.com/assets/anonymous-avatar-150x150-78bcd7e64bc228bd7bcf0b8c29c42a912d546dd2059ea0d573aaf7afd113f2ef.png"},"role":"Registered User","html_url":"https://seeclickfix.com/users/anonymous","civic_points":0},"media":{"video_url":null,"image_full":null,"image_square_100x100":null,"representative_image_url":"https://seeclickfix.com/assets/categories/signs-29b47a593f0542085ac302c6d95197f4c41d19a9199270c0a259d7cdfef995c0.png"}}],
  #   "errors":{}
  # }
  
  
  # I break up my methods into parts so they can be reused and it's easier to read
  
  # this method returns the json from the url provided
  def self.get_json(url="https://seeclickfix.com/api/v2/issues?status=open,acknowledged&page=5233&per_page=100")
    uri = URI(url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    return json
  end
  
  # this method collects the issues from all the pages of the response, since the greatest number of issues the SeeClickFix api display on a single page is 100
  def self.add_issues(json)
    issues = json["issues"]
    pages = json["metadata"]["pagination"]["pages"] # number of pages of issues for the query
    page = json["metadata"]["pagination"]["page"] # number of the page being currently displayed
    next_page_url = json["metadata"]["pagination"]["next_page_url"] # literally the link to the next page of issues for the query
    unless next_page_url.nil?
      while page <= pages
        json=Filter.get_json(next_page_url)
        next_page_url = json["metadata"]["pagination"]["next_page_url"]
        page = json["metadata"]["pagination"]["page"]
        pages = json["metadata"]["pagination"]["pages"]
        issues.push(json["issues"])
        puts "On Page #{page} of #{pages} Pages"
        break if next_page_url.nil?
      end
    end
    
    return issues
  end
  
  # this calls the other methods without latitude and longitude filters and returns all the issues
  def self.show_issues(url=Filter.get_last_page)
    json = Filter.get_json(url)
    issues = Filter.add_issues(json)
    return issues
  end
  
  # this calls the show method but includes latitude and longitude filters, along with a optional search filter
  # leaving the search empty has no impact beyond not providing additional filtering, and it takes a lot longer to get results since there will be so many
  def self.show_location_issues(lat=35.787743, lng=-78.644257, search='')
    url = Filter.get_last_page + "&lat=#{lat}&lng=#{lng}&sort=distance&search=#{search}"
    # url ="https://seeclickfix.com/api/v2/issues?status=open,acknowledged&lat=#{lat}&lng=#{lng}&sort=distance&per_page=100&search=#{search}"
    Filter.show_issues(url)
  end
  
  # temporarily I'm am just getting the last page of the results to speed up the load time
  def self.get_last_page(url="https://seeclickfix.com/api/v2/issues?status=open,acknowledged&per_page=100&sort_direction=ASC")
    json = Filter.get_json(url)
    pages = json["metadata"]["pagination"]["pages"]
    url = url + "&page=#{pages}"
    return url
  end
  
  def self.filters
    
  end
  
end
