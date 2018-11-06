class Filter < ApplicationRecord
    require "open-uri"
  require "net/http"
  require "json"
  
  # exaple of an issue reported to SeeClickFix
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
  def self.get_json(url="https://seeclickfix.com/api/v2/issues?status=open,acknowledged&page=5233&per_page=100")
    uri = URI(url)
    response = Net::HTTP.get(uri)
    json = JSON.parse(response)
    return json
  end
  
  def self.add_issues(json)
    issues = json["issues"]
    pages = json["metadata"]["pagination"]["pages"]
    page = json["metadata"]["pagination"]["page"]
    next_page_url = json["metadata"]["pagination"]["next_page_url"]
    unless next_page_url.nil?
      while page <= pages
        json=Filter.get_json(next_page_url)
        next_page_url = json["metadata"]["pagination"]["next_page_url"]
        page = json["metadata"]["pagination"]["page"]
        issues.push(json["issues"])
        break if next_page_url.nil?
      end
    end
    
    return issues
  end
  
  def self.show_issues(url="https://seeclickfix.com/api/v2/issues?status=open,acknowledged&page=5233&per_page=100" )
    json = Filter.get_json(url)
    issues = Filter.add_issues(json)
    return issues
  end
  
  def self.show_location_issues(lat=29.5859296, long=-95.5525199)
    # https://seeclickfix.com/api/v2/issues?lat=29.5859296&lng=-95.5525199&sort=distance&status=open,acknowledged&per_page=1&page=1
    url ="https://seeclickfix.com/api/v2/issues?status=open,acknowledged&lat=#{lat}&lng=#{long}&sort=distance&per_page=100"
    Filter.show_issues(url)
  end
  
end
