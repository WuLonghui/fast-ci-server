module Fast
  module Event
    class Push < Base
      def handle
        ref = payload["ref"]
        logger.info "Handle push, ref: #{ref}, pusher: #{payload["pusher"]}"
        
        git_branch = ref.gsub(/refs\/heads\//, '')
        logger.info "Build #{job.name} with #{git_branch}"
        jenkins_client.build_job(job.name, {:git_branch => git_branch})
      end
    end
  end
end