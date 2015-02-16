module Fast
  module Event
    class Base  
      extend Fast::EventDiscovery
          
      attr_reader :repository
      attr_reader :job
      attr_reader :payload
      
      def initialize(repository, payload)
        @repository = repository
        @job = repository.job
        @payload = payload
      end
      
      def logger
        Rails.logger
      end
      
      def jenkins_client
        Fast.jenkins_client(job.server_url)
      end
    end
  end
end
