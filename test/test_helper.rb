require "test/unit"
require "rack/test"
require "sinatra/basic_auth"
require "base64"

class Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    SampleApp
  end
end

class SampleApp < Sinatra::Base
  register Sinatra::BasicAuth

  # Default realm
  authorize do |username, password|
    username == "john" && password == "test"
  end

  protect do
    get("/") {"restricted content"}
  end

  # Custom realm
  authorize "MyApp" do |username, password|
    username == "mary" && password == "test"
  end

  protect "MyApp" do
    get("/myapp") {"restricted content for MyApp"}
  end
  
  # Custom Unauthorization message
  authorize "CustomUnauth" do |username, password|
    username == "mary" && password == "test"
  end
  
  unauthorized "CustomUnauth" do
    throw :halt, [401, "Custom failure message"]
  end

  protect "CustomUnauth" do
    get("/customunauth") {"restricted content for CustomUnauth"}
  end
  
end
