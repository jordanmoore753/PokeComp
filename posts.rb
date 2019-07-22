class Tournament
  attr_reader :generation, :tier, :date, :style, :title
  attr_accessor :users
  
  def initialize(generation, tier, style, date, title)
    @generation = generation
    @tier = tier
    @style = style
    @date = date
    @title = title
    @users = []
  end

  def add_user(user)
    @users << user
  end

  def remove_user(user)
    idx = @users.index(user)
    @users.delete_at(idx)
  end
end

class Post
  attr_reader :title, :date, :paragraphs, :user

  def initialize(title, date, paragraphs, user)
    @title = title
    @date = date
    @paragraphs = paragraphs
    @user = user
  end
end

class User
  attr_reader :user, :tourneys, :published, :teams, :messages

  def initialize(username, pw)
    @user = username
    @pw = pw
    @teams = []
    @tourneys = []
    @published = []
    @messages = []
  end

  def add_tourney(t_name)
    @tourneys << t_name
  end

  def remove_tourney(t_name)
    @tourneys.delete(t_name)
  end

  def add_article(t_name)
    @published << t_name
  end

  def remove_article(t_name)
    @published.delete(t_name)
  end

  def random
    pw
  end

  def add_team(team)
    @teams << team
  end

  def remove_team(team)
    @teams.delete(team)
  end

  def add_message(mesg)
    @messages << mesg
  end

  def delete_message(idx)
    @messages.delete_at(idx)
  end

  private

  attr_reader :pw
end

class Team
  attr_reader :pkmn

  def initialize(one, two, three, four, five, six)
    @pkmn = [one, two, three, four, five, six]
  end

  def each_pkmn(arr)
    arr.each do |pkmn|
      yield(pkmn)
    end
  end
end

class Message
  attr_reader :msg, :title

  def initialize(msg, title)
    @msg = msg
    @title = title
  end
end

me = User.new('de', 'we')
me.add_message(Message.new("oiii", "oiiii"))
p me.delete_message(0)
p me