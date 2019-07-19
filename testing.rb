require 'yaml'
require 'time'
require_relative "posts"
# a = {a: {'a' => [1, 2], 'b' => [2, 3]} }
# puts a.to_yaml

time = Time.new
p "#{time.month}/#{time.day}/#{time.year}"

me = Post.new("something", "#{time.month}/#{time.day}/#{time.year}", "fdklajldkja  jfldjafldjal;fj jfdlajl", "jon" )
p me