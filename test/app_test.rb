ENV["RACK_ENV"] = "test"

require "fileutils"
require "minitest/autorun"
require "rack/test"
require "bcrypt"
require_relative "../posts"
require_relative "../app"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    FileUtils.mkdir_p(data_path + "/users")
    FileUtils.mkdir_p(data_path + "/tournaments")
    FileUtils.mkdir_p(data_path + "/articles")
  end

  def teardown
    FileUtils.rm_rf(data_path)
  end

  def create_document(name, ext, content = "")
    File.open(File.join(data_path + ext, name), "w") do |file|
      file.write(content)
    end
  end

  def session
    last_request.env["rack.session"]
  end

  def register
    post "/register", params = {
      username: "ghost",
      password: "secret",
      confirm_pw: "secret",
      first: "Venusaur",
      second: "Venusaur",
      third: "Venusaur",
      fourth: "Venusaur",
      fifth: "Venusaur",
      sixth: "Venusaur"
    }
  end

  def login
    post "/login", params = { username: "ghost", password: "secret" }
  end

  def test_register
    setup
    get "/register"

    assert_includes last_response.body, "<form"

    register

    assert_equal "User ghost created.", session[:success]
 
  end

  def test_login
    register

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
    register

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
    create_document("One_More_Article.md", "/articles", "I love Pokemon!")
    create_document("Two_More_Article.md", "/articles", "I love Lamp!")
    create_document("Three_More_Article.md", "/articles", "# Heading! #")

    get "/articles"
    assert_includes last_response.body, "One"
    assert_includes last_response.body, "Two"
    assert_includes last_response.body, "Three"

  end

  def test_read_article
    create_document("One_More_Article.md", "/articles", "I love Pokemon!")
    create_document("Two_More_Article.md", "/articles", "I love Lamp!")
    create_document("Three_More_Article.md", "/articles", "# Heading! #")

    get "/4/read"
    assert_equal session[:error], "Article doesn't exist."

    get "/2/read"
    assert_includes last_response.body, "I love Pokemon!"
  end

  def test_create_article
    register
    login

    get "/new/article"

    assert_includes last_response.body, "<form"

    post "/new/article", params = {
      article: "# I love this app! #",
      title: "this_is_number_one_app"
    }

    assert_equal session[:success], "Article created."
  end

  def test_create_view_tournament
    register
    login 

    get "/new/tournament"

    assert_includes last_response.body, "<form"

    post "/new/tournament", params = {
      gen: "I",
      tier: "NU",
      style: "Doubles",
      date: "2019/08/17",
      title: "Great War of Pokes"
    }
    assert_equal session[:success], "Tournament created."

    get "/tournaments"

    assert_includes last_response.body, "Great War of Pokes"
  end
end