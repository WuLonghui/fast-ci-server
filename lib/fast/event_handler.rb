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
    
    def self.handle(repository, event, playload, options={})
      klass = @events[event]
      unless klass.nil?
        event = klass.new(repository, playload, options)
        event.handle if event.handle?
      end
    end
  end
end
