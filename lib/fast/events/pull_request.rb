module Fast
  module Event
    class PullRequest < Base
      def handle
        action = payload["action"]
        number = payload["number"]
        pull_request = payload["pull_request"] 
        head = pull_request["head"] 
        base = pull_request["base"] 
        commit = "#{head["sha"][0..6]}(#{base["ref"]})"
        committer = pull_request.fetch("user", {})["login"] || "unknown"
        pr_head_branch = "pr/#{number}/head"
        logger.info "Handle pull request, url: #{pull_request["html_url"]}, action: #{action}, commit: #{commit}, committer: #{committer}"
        
        unless action == "closed"
          logger.info "Build #{job.name}"
          build_params = {
            :git_branch => pr_head_branch,
            :build_history_info => "PR/#{number} #{commit} by #{committer}",
            :build_history_link => pull_request["html_url"]
          }
          jenkins_client.build_job(job.name, build_params)
        end
      end
    end
  end
end