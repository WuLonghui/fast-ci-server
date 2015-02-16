module Fast
  module Event
    class PullRequest < Base
      def handle
        action = payload["action"]
        number = payload["number"]
        pull_request = payload["pull_request"]
        logger.info "Handle pull request, url: #{pull_request["html_url"]}, action: #{action}"
        
        unless action == "closed"
          pr_head_branch = "pr/#{number}/head"
          logger.info "Build #{job.name} with #{pr_head_branch}"
          jenkins_client.build_job(job.name, {:git_branch => pr_head_branch})
        end
      end
    end
  end
end