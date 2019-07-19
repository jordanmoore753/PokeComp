class Tournament
  attr_reader :title, :requirements, :details, :date
  attr_accessor :users

  def initialize(title, requirements, details, date)
    @title = title
    @requirements = requirements
    @details = details
    @users = []
    @date = date
  end

  def add_user(user)
    @users << user
  end

  def remove_user(user)
    idx = @users.index(user)
    @users.delete_at(idx)
  end
end

class Message
  attr_reader :title, :details, :from_user, :to_user, :date
  attr_accessor :replies

  def initialize(title, details, from_user, to_user, date)
    @title = title
    @details = details
    @from_user = from_user
    @to_user = to_user
    @date = date
    @replies = []
  end

  def add_reply(reply)
    @replies << reply
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
