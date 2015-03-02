require "fast"

class WebhookController < ApplicationController
  def notify
    delivery = request.headers['X-GitHub-Delivery']
    logger.info "Webhook notity, github delivery: #{delivery}"  
    
    event = request.headers['X-GitHub-Event']
    payload = Fast::Payload.new(JSON.parse(request.body.read))

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
    
    logger.info "Event #{event} is from repository #{payload.repository.url}"
    
    repository = Repository.find_by_id(payload.repository.id)
    if repository.nil? then
      job_name = payload.repository.full_name.gsub(/\//, '.')
      logger.info "Create job #{job_name}"
      jenkins_client = Fast.jenkins_client
      job_options = {
        :git_url => payload.repository.url,
        :git_repository => payload.repository.full_name,
      }
      jenkins_client.create_or_update_job(job_name, job_options)
      job = Job.create(
        :name => job_name,
        :server_url => jenkins_client.server_url,
      )
      
      logger.info "Create repository #{payload.repository.full_name}"
      repository = Repository.create(
        :id => payload.repository.id,
        :full_name => payload.repository.full_name,
        :url => payload.repository.url,
        :job => job
      )
    end
    
    options = {}
    [:branches_except, :branches_only].each do |key|
      options[key] = params[key] if params.include?(key)
    end
    
    Fast::EventHandler.handle(repository, event, payload, options)
    
    success_render(200)
  rescue => err
    logger.error "Error raised: #{err.message}, #{err.backtrace}"
    error_render(500, err.message)
  end
end
