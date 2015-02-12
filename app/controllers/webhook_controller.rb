require "fast"

class WebhookController < ApplicationController
  def notify
    event = request.headers['X-GitHub-Event']
    playload = JSON.parse(request.body.read)  
    logger.info "Gihub event #{event} is triggered"
    
    Fast::EventHandler.handle(event, playload)
    
    success_render(200)
  end
end
