require "fast/event_handler"
require "fast/base_event"

Dir[File.dirname(__FILE__) + '/fast/events/**/*.rb'].each do |file|
  require file
end

module Fast
end
