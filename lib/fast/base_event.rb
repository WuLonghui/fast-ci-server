module Fast
  module Event
    class Base  
      extend Fast::EventDiscovery
          
      attr_reader :repository
      attr_reader :job
      attr_reader :payload
      attr_reader :options
      
      def initialize(repository, payload, options={})
        @repository = repository
        @job = repository.job
        @payload = payload
        @options = options
        init
      end
      
      def init
        # do some work here
      end
      
      def handle?
        true
      end
      
      def handle
        # do some work here
      end
      
      def logger
        Rails.logger
      end
      
      def jenkins_client
        Fast.jenkins_client(job.server_url)
      end
      
      def check_branch(branch)
        if options.include?(:branches_only) then
          branches = options[:branches_only].split(",")
          branches.each do |b|
            return true if branch == b
          end
          return false
        elsif options.include?(:branches_except) then
          branches = options[:branches_except].split(",")
          branches.each do |b|
            return false if branch == b
          end
          return true
        else
          return true
        end
      end
    end
  end
end
