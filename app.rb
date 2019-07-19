require "redcarpet"
require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
require "tilt/erubis"
require "rack"
require "yaml"
require "bcrypt"
require_relative "posts"

configure do
  enable :sessions
  set :session_secret, 'secret' 
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
    File.expand_path("../test/data/pokemon.yml", __FILE__)
  else
    File.expand_path("../data/pokemon.yml", __FILE__)
  end
  YAML.load_file(pkmn_path)
end

def load_user_list
  user_path = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/users.yml", __FILE__)
  else
    File.expand_path("../data/users.yml", __FILE__)
  end
  YAML.load_file(user_path)
end

def load_yml_list(yml)
  user_path = if ENV["RACK_ENV"] == "test"
    File.expand_path("../test/data/#{yml}.yml", __FILE__)
  else
    File.expand_path("../data/#{yml}.yml", __FILE__)
  end
  YAML.load_file(user_path)
end

def load_specific_user(username)
  @users.select { |user| user == username.to_sym }
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
  return false if @users.key?(username.to_sym)
  username.each_char { |chr| return false if invalid_chars.include?(chr) }
  true
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

def valid_credentials?(username, password, input)
  if @users.key?(username)
    bcrypt_password = BCrypt::Password.new(password)
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

def data_path #refactor this for testing also
  File.expand_path("../data", __FILE__)
end

get "/" do 
  @pkmn_list = load_pkmn_list
  @users = load_user_list
  @curr = load_specific_user("mike")
  erb :index
end

get "/login" do 
  erb :login
end

get "/register" do 
  @pkmn_list = load_pkmn_list.map { |pkmn| pkmn[0] } 
  erb :register
end

get "/:user/profile" do 
  @team = load_yml_list("teams").select { |key| key == params[:user].to_sym }.values.flatten
  erb :profile
end

get "/check_analysis" do
  @pkmn_list = load_pkmn_list.map { |pkmn| pkmn[0] }  
  erb :check_analysis
end

get "/counter_analysis" do 
  @pkmn_list = load_pkmn_list.map { |pkmn| pkmn[0] }  
  erb :counter_analysis
end

get "/:pkmn/results_check" do 
  @pkmn_list = load_pkmn_list
  @check_poke = @pkmn_list[session.delete(:curr_poke_check)]
  erb :results_check
end

get "/:pkmn/results_counter" do 
  @pkmn_list = load_pkmn_list
  @check_poke = @pkmn_list[session.delete(:curr_poke_check)]
  erb :results_counter
end

post "/login" do 
  @users = load_user_list
  @curr = load_specific_user(params[:username])
  user_sym = params[:username].to_sym

  if valid_credentials?(user_sym, @curr[user_sym][:password], params[:password])
    session[:success] = "#{params[:username]} logged in."
    session[:curr_user] = params[:username]
    redirect "/"
  else
    session[:error] = "Invalid credentials."
    erb :login
  end
end

post "/register" do
  @pkmn_list = load_pkmn_list.map { |pkmn| pkmn[0] }  
  @users = load_user_list
  @curr = load_specific_user(params[:username])
  user_sym = params[:username].to_sym

  if valid_username?(params[:username]) &&
     valid_password?(params[:password], params[:confirm_pw])

     session[:success] = "#{params[:username]} created." 
     path, team_path = yaml_path("users"), yaml_path("teams")
     write_to_users(path)
     write_to_teams(team_path)
     redirect "/"
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
  session[:curr_poke_check] = params[:pkmn]
  redirect "/#{params[:pkmn]}/results_check"
end

post "/counter_analysis" do 
  session[:curr_poke_check] = params[:pkmn]
  redirect "/#{params[:pkmn]}/results_counter"
end