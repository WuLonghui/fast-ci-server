require "fast"

class WebhookController < ApplicationController
  def notify
    event = request.headers['X-GitHub-Event']
    payload = Payload.new(request.body)
    repository = payload.repository
    logger.info "Event #{event} from #{repository["html_url"]} is triggered"
    
    if Repository.exists?(repository["id"]) then
    
    else
      Repository.create(
        :id => repository["id"],
      )
    end

    Fast::EventHandler.handle(event, payload)
    
    success_render(200)
  end
end
