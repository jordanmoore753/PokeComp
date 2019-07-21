ENV["RACK_ENV"] = "test"

require "fileutils"
require "minitest/autorun"
require "rack/test"
require "bcrypt"

require_relative "../app"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def create_document(name, content = "")
    File.open(File.join(data_path, name), "w") do |file|
      file.write(content)
    end
  end

  def session
    last_request.env["rack.session"]
  end

  def test_login
    get "/login"

    assert_includes last_response.body, "<form"

    post "/login", params = { username: "ghost", password: "secret" }
    assert_equal session[:success], "ghost logged in."
    assert_equal session[:curr_user], "ghost"
    # check to make sure it is index

    post "/logout"

    post "/login", params = { username: "ghost", password: "secre" }
    assert_nil session[:curr_user]
  end

  def test_logout
    post "/login", params = { username: "ghost", password: "secret" }
    assert_equal session[:success], "ghost logged in."
    assert_equal session[:curr_user], "ghost"

    post "/logout"
    assert_equal session[:success], "User signed out."
    assert_nil session[:curr_user]
  end

  def test_check
    get "/check_analysis"
    assert_includes last_response.body, "<form"

    post "/check_analysis", params = { pkmn: "Venusaur" }
    assert_equal session[:curr_poke_check], "Venusaur"

    get last_response["Location"]
    assert_includes last_response.body, "Blastoise"
  end

  def test_counter
    get "/counter_analysis"
    assert_includes last_response.body, "<form"

    post "/counter_analysis", params = { pkmn: "Venusaur" }
    assert_equal session[:curr_poke_check], "Venusaur"

    get last_response["Location"]
    assert_includes last_response.body, "Charizard"
  end

  def test_articles_index
    get "/articles"
    assert_includes last_response.body, "One More Article"
    assert_includes last_response.body, "Only Thing You Need"
    assert_includes last_response.body, "The Best Thing About Pokemon"
  end

  def test_read_article
    get "/4/read"
    assert_equal session[:error], "Article doesn't exist."

    get "/2/read"
    assert_includes last_response.body, "The Best Thing About Pokemon"
  end
end