class Subject

  def self.dir_exist(dir_name, project)
    return true if Dir.exist?(dir_name)

    puts dir_name + " folder doesnt exist, just create the dir and dwld the subject"
    FileUtils.mkdir_p(dir_name)
    return false if !Subject.dwld(dir_name, project.new_fname, project)
    puts "\n#{project.name} subject ok\n\n\n\n".green
    return false
  end

  def self.dwld(dir_name, f_name, project)
    puts "[Start dowloading " + f_name + " subject]"
    fpath = dir_name + '/' + f_name
    begin
      File.open(fpath, "wb") do |file|
        file.write open(project.dwld_url).read
      end
#    rescue OpenURI::HTTPError => ex
    rescue Exception => ex
      puts "\n****   #{ex}   ****\n".red
      #puts "****   404 error   ****"
      puts "project url: " + project.project_url
      puts "download url: " + project.dwld_url
      puts "\n\n\n\n"
      Utils.del(fpath)
       return false
    end
    return true
  end

  def self.get_subject_version(dir_name)
    puts "\n listing previous versions"
    files = Dir.glob(dir_name + "*.pdf")
    count = files.size
    if count == 0
    then
      return 1
    end
    array = Array.new()
    files.each { |file|
      # file :   ./Libft/archives/v3_Libft_Apr_17_20.pdf
      puts file
      f_name = File.basename(file)
      version = Integer(f_name[/\d+/])
      array << version
      puts "\n#{version}"
    }
    array = array.sort
    array.last + 1
  end

  def self.dwld_by_language(project, parent_folder)
    now = Time.now.strftime("_%b_%d_%y")
    project.new_fname = project.name + now + ".pdf"

    dir_name = "./" + parent_folder + '/' + project.name

    return if !dir_exist(dir_name, project)

    puts dir_name + " folder exist"
    files = Dir.glob(dir_name + "/*.pdf")
    count = files.size

    return if !Subject.dwld(dir_name, "temp.pdf", project)

    if count == 0
    then
      puts "No previous pdf, no comparison needed"
      File.rename(dir_name + "/temp.pdf", dir_name + "/" + project.new_fname)
      puts "\n#{project.name} subject ok\n\n\n\n".green
      return
    end
    old_fname = File.basename(files[0])

    (puts "\nError: pdf count in #{dir_name}/\n\n\n\n\n".red; return) if (count != 0 && count != 1)

    puts "Comparison needed; starting comparing..."
    if check_diff(files[0], dir_name + "/temp.pdf")
    then
      puts "[ different for: " + project.new_fname + " ]"
      archive_dir_name = dir_name + "/archives/"
      version = get_subject_version(archive_dir_name)

      FileUtils.mkdir_p(archive_dir_name) unless Dir.exist?(archive_dir_name)

      n_old_fname = archive_dir_name + "v#{version}" + "_" + old_fname
      File.rename(files[0], n_old_fname)
      File.rename(dir_name + "/temp.pdf", dir_name + "/" + project.new_fname)
      puts "\n[ new version added ]".magenta
    else
      puts "\n[ No differences between the old and the new subject ]"
      File.delete(dir_name + "/temp.pdf")
    end
    puts "\n#{project.name} subject ok\n\n\n\n".green
  end

  def self.dwld_subject(agent, project)
    project.dwld_url = scrap_dwld_url(agent, project)
   # project.dwld_url = "https://cdn.intra.42.fr/pdf/pdf/404_test/en.subject.pdf"
    return if project.dwld_url.nil?
    puts "       < download url ok >"
    
    dwld_by_language(project, "English")
    
    #project.dwld_url = Utils.get_french_url(project.dwld_url)
    #dwld_by_language(project, "French")
end

end
