module Fast
  module Event
    class Base  
      attr_reader :payload
      
      def initialize(payload)
        @payload = payload
      end
    end
  end
end
