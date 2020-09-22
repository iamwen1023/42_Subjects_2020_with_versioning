def intra_login(url)
  login = ENV['M_LOGIN']
  password = ENV['M_PWD']

  agent = Mechanize.new
  page = agent.get(url)
  form = page.forms.first

  form.field_with(:id => "user_login").value = login
  form.field_with(:id => "user_password").value = password

  form.submit
  agent
end

def scrap_dwld_url(agent, project)
  print "Scrapping #{project.name} dwld url,"
begin 

 page = agent.get project.project_url
  doc = Nokogiri::HTML(page.content.toutf8)

  div = doc.xpath("//div[@class='project-summary-item' or @class='x15']")

  sub_div = doc.xpath("//div[@class='project-attachment-item' or @class='x15']")
#       puts sub_div[0]

  if sub_div.at('a').nil?
  then
    caller_line = caller.first.split(":")[1]
    file_line = "#{__FILE__} : line #{caller_line}"
    #       Utils.die("Error: login to the Intra went wrong :/\n#{file_line}".red)
    puts "Error: login to the Intra went wrong (maybe) :/\n#{file_line}".red
    return nil
  end


  dwld_url = sub_div.at('a')["href"]
  puts "        Error while getting dwld url".red if dwld_url.nil?
  dwld_url

  rescue Exception => ex
  	puts "error scraping url" + project.project_url
	return nil
  end
end
