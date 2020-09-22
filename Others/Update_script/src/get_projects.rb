def skip_list(name)
	exclude = ["Exam", "Et ca fait", "bim bam boom"]
	exclude.each do |x|
		return true if name.include? x
	end
	return false
end

def get_projects_by_range(token, min, max)

  projects = Array.new()
  base_url = "https://projects.intra.42.fr/projects/"
  route = "/v2/cursus/21/projects"
  i = 1
#  puts m_headers = token.get(route, params: {page: {size: 100, number: 1}, range: {id: "1314, 1346"}}).headers

  loop do
    m_json = token.get(route, params: {page: {size: 100, number: i}, range: {id: "#{min}, #{max}"}}).parsed

    m_json.each do |x|

      name = x['name']
      url = base_url + x['slug']
      
      (puts ".skip #{name}"; next) if skip_list(name)

      project = Project.new
      project.name = name
      project.project_url = url
      puts "-#{name}"
      projects << project
    end

    i += 1
    sleep(0.51)
    break if !m_json.any?
  end
  projects
end

def get_projects(which_sub)

  puts "[ Getting projects url from API ]"

  token = Utils.get_token()
  min = 1314
  max = 1346
  if (which_sub == 1)
    min = 0
    max = 100000
  end
  projects = get_projects_by_range(token, min, max)

  puts "\n[ Projects url ok ]\n\n"
  projects
end
