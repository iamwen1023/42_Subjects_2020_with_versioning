require 'rubygems'
require 'open-uri'
require 'nokogiri'
require 'logger'
require 'mechanize'
require 'rubygems'
require 'json'
require "oauth2"
require 'dotenv/load'


Dir["./src/*.rb"].reject { |x| x == "./src/main.rb" }.each { |file|
  require file
}

which_sub = ARGV[0] == "all" ? 1 : 0

projects = get_projects(which_sub)

agent = intra_login("https://profile.intra.42.fr/")


total = projects.size

projects.each_with_index { |project, index|

  puts "#{index + 1} / #{total}"
  Subject.dwld_subject(agent, project)
  
}
