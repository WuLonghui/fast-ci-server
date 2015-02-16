require "fast"

class WebhookController < ApplicationController
  def notify
    event = request.headers['X-GitHub-Event']
    payload = Payload.new(request.body)

    if event == "ping" or !Fast::EventHandler.include_event?(event) then
      logger.info "Event #{event} is triggered"
      success_render(200)
      return
    end
    
    if payload.repository.nil? then
      logger.error "Repository in payload is nil"
      success_render(400)
      return
    end
    
    logger.info "Event is from repository #{payload.repository["html_url"]}"
    
    repository = Repository.find_by_id(payload.repository["id"])
    if repository.nil? then
      job_name = payload.repository["full_name"].gsub(/\//, '.')
      logger.info "Create job #{job_name}"
      jenkins_client = Fast.jenkins_client
      jenkins_client.create_or_update_job(job_name, {:git_url =>payload.repository["html_url"]})
      job = Job.create(
        :name => job_name,
        :server_url => jenkins_client.server_url,
      )
      
      logger.info "Create repository #{payload.repository["full_name"]}"
      repository = Repository.create(
        :id => payload.repository["id"],
        :full_name => payload.repository["full_name"],
        :html_url => payload.repository["html_url"],
        :job => job
      )
    end
    
    Fast::EventHandler.handle(repository, event, payload)
    
    success_render(200)
  rescue => err
    logger.error "Error raised: #{err.message}, #{err.backtrace}"
    error_render(500, err.message)
  end
end
