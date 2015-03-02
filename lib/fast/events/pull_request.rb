module Fast
  module Event
    class PullRequest < Base  
      def init    
        @action = payload["action"]
        @number = payload["number"]
        @pull_request = payload["pull_request"] 
        @head = @pull_request["head"] 
        @base = @pull_request["base"] 
        @commit = "#{@head["sha"][0..6]}(#{@base["ref"]})"
        @committer = @pull_request.fetch("user", {})["login"] || "unknown"         
      end
     
      def handle?
        check_branch(@base["ref"])
      end  
      
      def handle
        logger.info "Handle pull request, url: #{@pull_request["html_url"]}, action: #{@action}, commit: #{@commit}, committer: #{@committer}"
        
        unless @action == "closed"   
          pr_head_branch = "pr/#{@number}/head"         
          build_params = {
            :git_branch => @pr_head_branch,
            :build_history_info => "PR/#{@number} #{@commit} by #{@committer}",
            :build_history_link => @pull_request["html_url"]
          }
          logger.info "Build #{job.name}, build_params: #{build_params}"
          jenkins_client.build_job(job.name, build_params)
        end
      end
    end
  end
end