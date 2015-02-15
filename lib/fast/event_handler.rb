module Fast
  class EventHandler
    def self.handle(repository, event, playload)
      klass = {
                 "push" => Fast::Event::Push,
                 "pull_request" => Fast::Event::PullRequest,
              }[event]
      
      unless klass.nil?
        klass.new(repository, playload).handle
      end
    end
  end
end
