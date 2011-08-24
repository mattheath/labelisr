# Labelisr
#   Maintain labels in GitHub Issues for one or more repositories
#
# Author:: Matt Heath <hi@mattheath.com>
# License:: MIT <http://www.opensource.org/licenses/mit-license.php>

require 'json'
require 'net/http'
require 'net/https'

user = ''
repo = ''
pass = ''

STDOUT.sync = true

http = Net::HTTP.new('api.github.com', 443)
http.use_ssl = true
http.start do |http|
	req = Net::HTTP::Get.new("/repos/#{user}/#{repo}/labels")

	# use HTTP basic auth by passing the
	# username and password
	req.basic_auth user, pass

	# make the request
	resp, data = http.request(req)

	# parse the returned JSON into a hash
	result = JSON.parse(data)

	# output the hashes
	puts result

	#output a list of the labels the repository has
	result.each { |label|
		puts label['name']
	}

end