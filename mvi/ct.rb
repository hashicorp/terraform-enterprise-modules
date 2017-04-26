# This script can be used to generate a list of IAM perms from 
# cloudtrail logs. It was used to generate the mvi profile.
require 'json'

perms = []

ARGV.each do |file|
  data = JSON.parse File.read(file)

  data['Records'].each do |rec|
    user = rec['userIdentity']
    next unless user['userName'] == "tfe"

    service = rec['eventSource'][0...-(".amazonaws.com".size)]

    perms << %Q!"#{service}:#{rec['eventName']}",!
  end
end

perms.sort.uniq.each do |perm|
  puts perm
end
