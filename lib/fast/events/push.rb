module Fast
  module Event
    class Push < Base
      def init
        @head_commit = payload["head_commit"]
        @pusher = payload["pusher"]["name"]   
        @ref = payload["ref"]
        @branch = @ref.gsub(/refs\/heads\//, '')
      end
      
      def handle?
        check_branch(@branch)
      end
      
      def handle  
        logger.info "Handle push, ref: #{@ref}, head_commit: #{@head_commit["url"]}, pusher: #{@pusher}"
      
        build_params = {
          :git_branch => @branch,
          :build_history_info => "Push #{@head_commit["id"][0..6]}(#{@branch}) by #{@pusher}",
          :build_history_link => URI.join(repository.url+"/", "commits/", @branch).to_s
        }
        logger.info "Build #{job.name}, build_params: #{build_params}"
        jenkins_client.build_job(job.name, build_params)
      end
    end
  end
end