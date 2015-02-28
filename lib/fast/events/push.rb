module Fast
  module Event
    class Push < Base
      def handle
        ref = payload["ref"]
        head_commit = payload["head_commit"]
        pusher = payload["pusher"]["name"]   
        git_branch = ref.gsub(/refs\/heads\//, '')        
        logger.info "Handle push, ref: #{ref}, head_commit: #{head_commit["url"]}, pusher: #{pusher}"
       
        logger.info "Build #{job.name}"
        build_params = {
          :git_branch => git_branch,
          :build_history_info => "Push #{head_commit["id"][0..6]}(#{git_branch}) by #{pusher}",
          :build_history_link => URI.join(repository.url+"/", "commits/", git_branch).to_s
        }
        jenkins_client.build_job(job.name, build_params)
      end
    end
  end
end