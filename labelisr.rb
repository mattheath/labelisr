#!/usr/bin/env ruby

# Labelisr
#   Maintain labels in GitHub Issues for one or more repositories
#
# Author:: Matt Heath <hi@mattheath.com>
# License:: MIT <http://www.opensource.org/licenses/mit-license.php>

require 'trollop'
require 'json'
require 'net/http'
require 'net/https'

STDOUT.sync = true

opts = Trollop::options do
	opt :user, "User name", :short => "-u", :type => :string
	opt :password, "Password for your GitHub account, optional", :short => "-p", :type => :string
	opt :repo, "Repository to work on", :type => :string
end

user = opts[:user]
repo = opts[:repo]

puts "Username: #{user}"
if opts.has_key?(:password_given)
	pass = opts[:password]
else
	print "Please enter your password: "
	pass = STDIN.gets
end

http = Net::HTTP.new('api.github.com', 443)
http.use_ssl = true
http.start do |http|
	req = Net::HTTP::Get.new("/repos/#{repo}/labels")

	# use HTTP basic auth by passing the
	# username and password
	req.basic_auth user, pass

	# make the request
	resp, data = http.request(req)

	# parse the returned JSON into a hash
	result = JSON.parse(data)

	#output a list of the labels the repository has
	result.each { |label|
		puts label['name']
	}

end