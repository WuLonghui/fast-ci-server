module Fast
  class EventHandler
    def self.handle(event, playload)
      klass = {
                 "push" => Fast::Event::Push,
                 "pull_request" => Fast::Event::PullRequest,
              }[event]
      
      unless klass.nil?
        klass.new(playload).handle
      end
    end
  end
end
