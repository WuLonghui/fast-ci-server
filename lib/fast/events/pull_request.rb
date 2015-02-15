module Fast
  module Event
    class PullRequest < Base
      def handle
        action = payload["action"]
        number = payload["number"]
        pull_request = payload["pull_request"]
        logger.info "Handle pull request, url: #{pull_request["html_url"]}, action: #{action}"        
      end
    end
  end
end