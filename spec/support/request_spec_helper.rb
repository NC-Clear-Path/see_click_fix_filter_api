# spec/support/request_spec_helper
module RequestSpecHelper
  # Parse JSON response to ruby hash
  def index
    JSON.parse(response.body)
  end
end