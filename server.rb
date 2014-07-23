require 'json'
require 'webrick'
include WEBrick
myserver = HTTPServer.new(:Port => 4096,
:DocumentRoot => "runjs.html")

trap 'INT' do myserver.shutdown end


$question={"question"=>"What is 1+1?", "choice 1"=>"1+1", "choice 2"=>"2"}

def get_question req  #serve the question possibly based on the request
  return $question
end

class ServeQuestion < WEBrick::HTTPServlet::AbstractServlet
  def do_GET request, response

    response.chunked = true
    response.status = 200
    response['content-type'] = 'text/javascript'
    
    response.body = get_question(request).to_json

  end
  
  def do_POST request, response
    req=request.body  #the choice is returned from the client side
    puts req  
  end
  
end

myserver.mount "/question", ServeQuestion
myserver.start

