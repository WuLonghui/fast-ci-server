class Payload
  def initialize(body)
    @payload = JSON.parse(body.read)      
  end
  
  def [](k)
    @payload[k]
  end
      
  def repository
    @payload["repository"]
  end
end
