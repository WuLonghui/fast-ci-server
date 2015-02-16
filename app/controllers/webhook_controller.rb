require "fast"

class WebhookController < ApplicationController
  def notify
    event = request.headers['X-GitHub-Event']
    payload = Payload.new(request.body)
    
    if event == "ping" then
      logger.info "Event #{event} is triggered"
      success_render(200)
      return
    end
    
    if payload.repository.nil? then
      logger.error "Repository in payload is nil"
      success_render(400)
      return
    end
    
    logger.info "Event #{event} from #{payload.repository["html_url"]} is triggered"
    
    repository = Repository.find_by_id(payload.repository["id"])
    if repository.nil? then
      jenkins_client = Fast.jenkins_client
      job_name = payload.repository["name"]
      jenkins_client.create_or_update_job(job_name, {:git_url =>payload.repository["html_url"]})
      
      job = Job.create(
        :name => job_name,
        :server_url => jenkins_client.server_url,
      )
      
      repository = Repository.create(
        :id => payload.repository["id"],
        :full_name => payload.repository["full_name"],
        :html_url => payload.repository["html_url"],
        :job => job
      )
    end
    
    Fast::EventHandler.handle(repository, event, payload)
    
    success_render(200)
  end
end
