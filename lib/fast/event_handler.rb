module Fast
  class EventHandler
    class << self
      attr_reader :events
    end
    
    @events = {}
    
    def self.register_event(event, klass)
      @events[event] = klass
    end
    
    def self.include_event?(event)    
      @events.has_key?(event)
    end
    
    def self.handle(repository, event, playload)
      klass = @events[event]
      unless klass.nil?
        klass.new(repository, playload).handle
      end
    end
  end
end
