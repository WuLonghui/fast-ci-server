require 'uri'
require "erb"
require 'jenkins_api_client'

require "fast/event_discovery"
require "fast/event_handler"
require "fast/base_event"
require "fast/payload"

Dir[File.dirname(__FILE__) + '/fast/events/**/*.rb'].each do |file|
  require file
end

module Fast
  def self.jenkins_client(jenkins_url = nil)
    jenkins_master = Settings["jenkins_master"]
    jenkins_url = jenkins_url || jenkins_master["url"]
    jenkins_admin_user = jenkins_master["admin_user"]
    jenkins_admin_password = jenkins_master["admin_password"]
    jenkins_client = Fast::JenkinsClient.new({
        :server_url => jenkins_url,
        :username => jenkins_admin_user,
        :password => jenkins_admin_password
    })  
  end
end
