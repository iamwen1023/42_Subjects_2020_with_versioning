class Utils
  def self.die(message)
    STDERR.puts(message)
    exit(1)
  end

  def self.get_token
    uid = ENV["M_UID"]
    secret = ENV["M_SECRET"]

    client = OAuth2::Client.new(uid, secret, site: "https://api.intra.42.fr")
    client.client_credentials.get_token
  end

  def self.del(path)
	File.delete(path) if File.exist?(path)
  end

  def self.get_french_url(url)
	splitted = url.split('/')
	id = splitted[5].to_i
	id += 1
	"https://cdn.intra.42.fr/pdf/pdf/#{id}/fr.subject.pdf"
  end

end






class String
	def red;            "\e[31m#{self}\e[0m" end
	def green;          "\e[32m#{self}\e[0m" end
	def magenta;        "\e[35m#{self}\e[0m" end
	def cyan;           "\e[36m#{self}\e[0m" end

	def bold;           "\e[1m#{self}\e[22m" end
	def italic;         "\e[3m#{self}\e[23m" end
	def underline;      "\e[4m#{self}\e[24m" end
end
