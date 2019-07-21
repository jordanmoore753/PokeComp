require 'yaml'
require 'time'

require_relative "posts"
# a = {a: {'a' => [1, 2], 'b' => [2, 3]} }
# puts a.to_yaml

time = Time.new
p "#{time.month}/#{time.day}/#{time.year}"
p "%02d" % time.month
me = Post.new("something", "#{time.month}/#{time.day}/#{time.year}", "fdklajldkja  jfldjafldjal;fj jfdlajl", "jon" )
p me
p me.to_yaml
#generation, tier, style, details, date)
y = Tournament.new("e", "3e", "3er", "er", "er")
p y
p y.to_yaml
y.add_user("clifot")
p y.to_yaml
t = "fdaf fdafd afda"
a = [1, 2]
a.delete(2)
p a
a = [['a', 'b', 'c'], ['d', 'e', 'f']]
a.delete(['a', 'b', 'c'])
p a
  p t.gsub(' ', '_')
 p a = "/users/*"
 a.gsub!('*', '') 
 p a

 b = "iamgoingtotooooo.yml"
 p b[0..-5]