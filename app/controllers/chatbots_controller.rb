require 'net/http'
require 'json'

class ChatbotsController < ApplicationController
  def create
    prompt = params[:message]

    response = Net::HTTP.post(
      URI('http://localhost:11434/api/generate'),
      { model: "llama2", prompt: prompt }.to_json,
      { "Content-Type" => "application/json" }
    )

    json = JSON.parse(response.body)

    render turbo_stream: turbo_stream.append(
      "chatbot_response",
      partial: "chatbots/response",
      locals: { message: prompt, reply: json["response"] }
    )
  end
end
