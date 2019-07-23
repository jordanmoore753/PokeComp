require "redcarpet"
require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"
require "rack"
require "yaml"
require "bcrypt"
require "time"
require "psych"
require_relative "posts"

configure do
  enable :sessions
  set :session_secret, 'secret' 
end

before do 
  @articles = sorted_articles
  @tournaments = sorted_tourneys
  @users = sorted_users
end

def sorted_articles
  pattern = data_path + "/articles/*"
  articles = Dir.glob(pattern).map do |path|
    File.basename(path)
  end
  sort_articles(articles)
end

def sorted_tourneys 
  tournament_pattern = data_path + "/tournaments/*"
  tournaments = Dir.glob(tournament_pattern).map do |path|
    File.basename(path)
  end
  sort_tournaments(tournaments)
end

def sorted_users
  pattern = data_path + "/users/*"
  Dir.glob(pattern).map { |path| File.basename(path) }.sort
end

def user_with_ext
  session[:curr_user] + '.yml'
end

def data_path
  if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data", __FILE__)
  else
    File.expand_path("../data", __FILE__)
  end
end

def yaml_path(name_of_file)
  if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/#{name_of_file}.yml", __FILE__)
  else
    File.expand_path("../data/#{name_of_file}.yml", __FILE__)
  end 
end

def load_pkmn_list
  pkmn_path = if ENV["RACK_ENV"] == "test"
    File.expand_path("../pokemon.yml", __FILE__)
  else
    File.expand_path("../pokemon.yml", __FILE__)
  end
  YAML.load_file(pkmn_path)
end

def load_yml_list(yml)
  user_path = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/#{yml}.yml", __FILE__)
  else
    File.expand_path("../data/#{yml}.yml", __FILE__)
  end
  YAML.load_file(user_path)
end

def load_yml_tourney_list(yml)
  file = tournament_file_name(yml)
  user_path = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/tournaments/#{yml}", __FILE__)
  else
    File.expand_path("../data/tournaments/#{yml}", __FILE__)
  end
  YAML.load_file(user_path)
end

def load_all_yml_tourney(yml)
  user_path = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/tournaments/#{yml}", __FILE__)
  else
    File.expand_path("../data/tournaments/#{yml}", __FILE__)
  end
  YAML.load_file(user_path)
end

def load_yml_user(yml)
  user_path = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/users/#{yml}.yml", __FILE__)
  else
    File.expand_path("../data/users/#{yml}.yml", __FILE__)
  end
  YAML.load_file(user_path)
end

def load_yml_user_no_ext(yml)
  user_path = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/users/#{yml}", __FILE__)
  else
    File.expand_path("../data/users/#{yml}", __FILE__)
  end
  YAML.load_file(user_path) 
end

def load_noncurrent_users(username)
  all_users.select { |u| u.user != username }
end

def load_specific_user(username)
  @users.select { |user| user[0..-5] == username }
end

def display_pkmn_name_type(pokemon)
  curr_pkmn = find_pkmn_by_name(pokemon)
  pkmn_name = curr_pkmn[0]
  pkmn_type = curr_pkmn[1][:type]
  pkmn_type = pkmn_type.map { |type| "<img src='/img/#{type}.png'>"}
  pkmn_picture = File.join(data_path, pkmn_name + ".png")

  "#{pkmn_name} <img src='/img/#{pkmn_name}.png'>  #{pkmn_type.join(' ')}"
end

def display_pkmn_counters(pokemon)
  curr_pkmn = find_pkmn_by_name(pokemon)
  curr_pkmn[1][:walls]
end

def display_pkmn_checks(pokemon)
  curr_pkmn = find_pkmn_by_name(pokemon)
  curr_pkmn[1][:attacker]
end

def all_pkmn_names
  @poke.map { |pokemon| pokemon[0] }
end

def find_pkmn_by_name(pkmn)
  selected = []
  @pkmn_list.each { |pk| selected << pk if pk[0] == pkmn }
  selected.flatten
end

def valid_username?(username)
  invalid_chars = %w(! @ # $ % ^ & * ( ) - _ + = / ] [ } { : ; ' " . , ? ` ~ < >) << ' '
  @users.each { |obj| return false if obj.user == username }
  username.each_char { |chr| return false if invalid_chars.include?(chr) }
  true
end

def scrambled_word
  BCrypt::Password.create("secret").split('').reject! { |chr| chr =~ /[^a-z0-9]/i }.join('')
end

def all_users
  pattern = data_path + "/users/*"
  users = Dir.glob(pattern).map do |path|
    File.basename(path)
  end

  pattern.gsub!('*', '')
  users.map { |file| YAML.load_file(pattern + file) }
end

def find_user(username)
  users = all_users
  users.each { |obj| return obj if obj.user == username }
  false
end

def find_user_by_idx(idx)
  users = all_users
  users.each { |obj| return obj if obj.user == username }
  false
end

def valid_password?(password, confirm_pw)
  password == confirm_pw
end

def load_user_credentials
  credentials_path = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/users.yml", __FILE__)
  else
    File.expand_path("../users.yml", __FILE__)
  end
  YAML.load_file(credentials_path)
end

def valid_credentials?(obj, username, obj_two, input)
  if obj.user == username
    bcrypt_password = BCrypt::Password.new(obj_two)
    bcrypt_password == input
  else
    false
  end
end

def write_to_users(data_path_yml)
  File.open(data_path_yml, 'a') do |yml|
    yml.puts ":#{params[:username]}:"
    yml.puts "  :username: #{params[:username]}"
    yml.puts "  :password: #{BCrypt::Password.create(params[:password])}"
  end
end

def write_to_teams(data_path_yml)
  File.open(data_path_yml, 'a') do |yml|
    yml.puts ":#{params[:username]}:"
    yml.puts "- #{params[:first]}"
    yml.puts "- #{params[:second]}"
    yml.puts "- #{params[:third]}"
    yml.puts "- #{params[:four]}"
    yml.puts "- #{params[:fifth]}"
    yml.puts "- #{params[:six]}"
  end
end

def write_to_posts(data_path_yml, post_object)
  File.open(data_path_yml, 'a') do |yml|
    yml.puts ":#{BCrypt::Password.create("key")}:"
    yml.puts "- #{post_object.title}"
    yml.puts "- #{post_object.date}"
    yml.puts "- #{post_object.paragraphs}"
    yml.puts "- #{post_object.user}"
  end 
end

def no_scripts?(para)
  invalid = ["<script>", "</script>", "<script"]
  invalid.each { |word| return false if para.include?(word) }
  true
end

def article_title(file)
  title = file.split('_')
  title[0..title.size - 3].map(&:capitalize).join(' ')
end

def article_user(file)
  file.split('_')[-2]
end

def article_date(file)
  date = file.split('_')[-1]
  date = date[0..date.length - 4]
  date.insert(2, "/")
  date.insert(5, "/")
end

def sort_articles(arr)
  arr.sort_by do |file_name|
    file_name[-7..-4].to_i
  end.reverse
end

def sort_tournaments(arr)
  arr.sort_by do |file_name|
    file_name[-8..-5].to_i
  end
end

def load_file_content(path)
  content = File.read(path)
  case File.extname(path)
  when ".txt"
    headers["Content-Type"] = "text/plain"
    content
  when ".md"
    headers["Content-Type"] = "text/html"
    render_markdown(content)
  end
end

def md_file_exists?(file)
  @articles.size >= file.to_i + 1
end

def file_doesnt_exist?(file)
  @articles.include?(file)
end

def title_no_invalid_chars?(title)
  invalid_chars = %w(! @ # $ % ^ & * ( ) - + = / ] [ } { : ; ' " . , ? ` ~ < >) << ' '
  title.each_char { |chr| return false if invalid_chars.include?(chr) }
  @articles.each { |file| return false if file.include?(title) }
  true
end

def valid_msg?(msg, title)
  invalid_chars = %w(( ) - + = ] [ } { ~ < >)
  msg.each_char { |chr| return false if invalid_chars.include?(chr) } 
  title.each_char { |chr| return false if invalid_chars.include?(chr) }
  return false if msg.empty? || title.empty?
  true
end

def logged_in?
  if session[:curr_user].nil?
    session[:error] = "Must be logged in to perform that action."
    redirect "/login" 
  end
end

def valid_tournament_title?(title)
  invalid_chars = %w(! @ # $ % ^ & * ( ) - + = / ] [ } { : ; ' " . , ? ` ~ < >)
  title.each_char { |chr| return false if invalid_chars.include?(chr) }
  @tournaments.each { |file| return false if file.include?((title + '.yml').split(' ').join('_')) }
  true
end

def tournament_file_name(title)
  title.gsub(' ', '_')
end

def update_user_tourneys(idx, username)
  usr = find_user(username)
  return false if usr == false

  curr_tourney = load_yml_tourney_list(@tournaments[idx]).title
  usr.add_tourney(curr_tourney)
  File.open(users_path, 'w') { |file| file.write(usr.to_yaml) }
end

def update_tourney_users(idx, username)
  curr_tourney = load_yml_tourney_list(@tournaments[idx])
  curr_tourney.add_user(username)

  path = data_path + "/tournaments/" 
  file_name = tournament_file_name(curr_tourney.title.gsub(' ', '_') + ".yml")
  file_path = File.join(path, file_name) 
  File.open(file_path, 'w') { |file| file.write(curr_tourney.to_yaml) } 
end

def update_user_articles(article, username)
  usr = find_user(username)
  return false if usr == false

  usr.add_article(article)
  File.open(users_path, 'w') { |file| file.write(usr.to_yaml) }
end

def update_user_msg(msg, username)
  usr = find_user(username)
  return false if usr == false

  path = data_path + "/users/"
  file_name = "#{username}.yml"
  file_path = File.join(path, file_name) 

  usr.add_message(msg)
  File.open(file_path, 'w') { |file| file.write(usr.to_yaml) }  
end

def delete_user_msg(id, username)
  usr = find_user(username)
  return false if usr == false

  path = data_path + "/users/"
  file_name = "#{username}.yml"
  file_path = File.join(path, file_name) 

  usr.delete_message(id)
  File.open(file_path, 'w') { |file| file.write(usr.to_yaml) }  
end

def update_user_team(team, username)
  usr = find_user(username)
  return false if usr == false

  path = data_path + "/users/"
  file_name = "#{usr.user}.yml"
  file_path = File.join(path, file_name)

  team = Team.new(team[0], team[1], team[2], team[3], team[4], team[5])
  usr.add_team(team)
  File.open(file_path, 'w') { |file| file.write(usr.to_yaml) }
end

def render_markdown(file)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(file)
end

def create_user_yml(obj)
  path = data_path + "/users/"
  file_name = "#{obj.user}.yml"
  file_path = File.join(path, file_name)
  File.open(file_path, 'w') { |file| file.write(obj.to_yaml) }
end

def create_user(username, pw)
  User.new(username, BCrypt::Password.create(params[:password]).split('').join('')) 
end

def users_path
  path = data_path + "/users/"
  file_path = File.join(path, "#{session[:curr_user]}.yml") 
end

def msg_idx_exists?(user, idx)
  user.messages.each_with_index { |msg, i| return true if idx == i }
  false
end

get "/" do 
  logged_in?

  redirect "/profile"
end

get "/login" do 
  erb :login
end

get "/register" do 
  @pkmn_list = load_pkmn_list.map { |pkmn| pkmn[0] } 
  erb :register
end

get "/profile" do
  logged_in?
  @curr_user = find_user(session[:curr_user])
  erb :profile
end

get "/messages" do
  logged_in?
  @curr_user = find_user(session[:curr_user])
  erb :messages
end

get "/send_message" do
  logged_in? 
  @noncurrent_users = load_noncurrent_users(session[:curr_user])
  @curr_user = find_user(session[:curr_user])
  erb :send_message
end

post "/send_message" do 
  logged_in?

  if valid_msg?(params[:message], params[:title])
    title = params[:title] + ", from #{session[:curr_user]}."
    msg = Message.new(params[:message], title)
    update_user_msg(msg, params[:receiver])
    session[:success] = "Message sent."
    redirect "/profile"
  else
    session[:error] = "Message or title contained invalid characters."
    redirect "/send_message"
  end
end

post "/:idx/delete_message" do 
  logged_in? 
  @curr_user = find_user(session[:curr_user])
  idx = params[:idx].to_i

  if msg_idx_exists?(@curr_user, idx)
    delete_user_msg(idx, session[:curr_user])
    session[:success] = "Message deleted."
  else
    session[:error] = "Could not locate message."
  end

  redirect "/profile"
end

get "/check_analysis" do
  logged_in?
  @pkmn_list = load_pkmn_list.map { |pkmn| pkmn[0] }  
  erb :check_analysis
end

get "/counter_analysis" do
  logged_in? 
  @pkmn_list = load_pkmn_list.map { |pkmn| pkmn[0] }  
  erb :counter_analysis
end

get "/:pkmn/results_check" do
  logged_in? 
  @pkmn_list = load_pkmn_list
  @check_poke = @pkmn_list[session.delete(:curr_poke_check)]
  erb :results_check
end

get "/:pkmn/results_counter" do
  logged_in?  
  @pkmn_list = load_pkmn_list
  @check_poke = @pkmn_list[session.delete(:curr_poke_check)]
  erb :results_counter
end

get "/articles" do
  logged_in?
  erb :articles
end

get "/:idx/read" do
  logged_in? 

  if md_file_exists?(params[:idx])
    file_name = @articles[params[:idx].to_i]
    path = data_path + "/articles/"
    file_path = File.join(path, file_name)
    @article = load_file_content(file_path)
    @title, @date = article_title(file_name), article_date(file_name)
    @user = article_user(file_name)
    erb :read_article
  else
    session[:error] = "Article doesn't exist."
    redirect "/"
  end
end

get "/new/article" do
  logged_in? 
  erb :new_article
end

get "/tournaments" do
  logged_in?

  @path = data_path + '/tournaments/'
  @tourneys = @tournaments.map { |file| load_yml_tourney_list(file) }

  erb :tournaments
end

get "/new/tournament" do
  logged_in?  
  erb :new_tournament
end

post "/new/tournament" do
  logged_in?

  if valid_tournament_title?(params[:title])
    #(generation, tier, style, date, title)
    tourney = Tournament.new(params[:gen], params[:tier], params[:style], params[:date], params[:title])

    path = data_path + "/tournaments/" 
    file_name = tournament_file_name(params[:title]) + ".yml"
    file_path = File.join(path, file_name) 
    File.open(file_path, 'w') { |file| file.write(tourney.to_yaml) }
    session[:success] = "Tournament created."
    redirect "/tournaments"
  else
    session[:error] = "Invalid characters in title or title already exists."
    erb :new_tournament
  end
end

post "/:idx/signup" do 
  logged_in?

  @idx = params[:idx].to_i
  update_user_tourneys(@idx, session[:curr_user])
  update_tourney_users(@idx, session[:curr_user])
  session[:success] = "Signed up for tournament."
  redirect "/tournaments"
end

post "/new/article" do
  logged_in?  

  if title_no_invalid_chars?(params[:title]) && no_scripts?(params[:article])
    path = data_path + "/articles/"
    if params[:title][-1] == '_'
      title = params[:title]
    else
      title = params[:title] + '_'
    end

    time = Time.new
    m, y = "%02d" % time.month, time.year
    d = "%02d" % time.day
    user = session[:curr_user] 
    file_name = "#{title}#{user}_#{m}#{d}#{y}.md"
    file_path = File.join(path, file_name)
    File.open(file_path, 'w') { |file| file.write(params[:article]) }
    update_user_articles(params[:title], session[:curr_user])
    session[:success] = "Article created."
    redirect "/articles"
  else
    session[:error] = "Title already exists or invalid inputs."
    erb :new_article
  end
end

post "/login" do 
  @user = find_user(params[:username])
  @users = all_users

  if @user != false && valid_credentials?(@user,
                        params[:username], 
                        @user.random, 
                        params[:password])

    session[:success] = "#{params[:username]} logged in."
    session[:curr_user] = params[:username]
    redirect "/profile"
  else
    session[:error] = "Invalid credentials."
    erb :login
  end
end

post "/register" do
  @users = all_users
  @pkmn_list = load_pkmn_list

  if valid_username?(params[:username]) &&
     valid_password?(params[:password], params[:confirm_pw])

    obj = create_user(params[:username], params[:password])
    team = [params[:first], 
            params[:second], 
            params[:third],
            params[:fourth],
            params[:fifth],
            params[:sixth]]

    create_user_yml(obj)
    update_user_team(team, params[:username])
    session[:success] = "User #{obj.user} created."
    redirect "/login"
  else
    session[:error] = "Try another username or ensure your passwords match."
    erb :register
  end
end

post "/logout" do 
  session.delete(:curr_user)
  session[:success] = "User signed out."
  redirect "/"
end

post "/check_analysis" do
  logged_in?  
  session[:curr_poke_check] = params[:pkmn]
  redirect "/#{params[:pkmn]}/results_check"
end

post "/counter_analysis" do
  logged_in?  
  session[:curr_poke_check] = params[:pkmn]
  redirect "/#{params[:pkmn]}/results_counter"
end

post "/submit_check" do
  logged_in?  
  @pkmn_list = load_pkmn_list

  if no_scripts?(params[:explain])
    title = "#{params[:second_pkmn]} is checked by #{params[:first_pkmn]}."
    paragraphs = params[:explain].split("\n")
    time = Time.new
    user = session[:curr_user]
    new_post = Post.new(title, "#{time.month}/#{time.day}/#{time.year}",
                        paragraphs, user)
    path = yaml_path("requests")
    write_to_posts(path, new_post)
    session[:success] = "Submission successfully created."
    redirect "/"
  else
    session[:error] = "No HTML allowed."
    redirect "/check_analysis"
  end
end

post "/submit_counter" do
  logged_in? 
  @pkmn_list = load_pkmn_list

  if no_scripts?(params[:explain])
    title = "#{params[:second_pkmn]} is counter to #{params[:first_pkmn]}."
    paragraphs = params[:explain].split("\n")
    time = Time.new
    user = session[:curr_user]
    new_post = Post.new(title, "#{time.month}/#{time.day}/#{time.year}",
                        paragraphs, user)
    path = yaml_path("requests")
    write_to_posts(path, new_post)
    session[:success] = "Submission successfully created."
    redirect "/"
  else
    session[:error] = "No HTML allowed."
    redirect "/counter_analysis"
  end
end
