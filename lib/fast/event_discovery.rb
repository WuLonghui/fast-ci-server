module Fast
  module EventDiscovery    
    def inherited(klass)
      event = klass.to_s[13..-1].gsub(/(?=[A-Z])/, "_").downcase[1..-1]
      Fast::EventHandler.register_event(event, klass)
    end 
  end
end
