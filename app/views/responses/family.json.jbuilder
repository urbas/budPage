json.partial! 'responses/response', response: @response

json.parent_response do
  if @response.parent_response
    json.partial! 'responses/response', response: @response.parent_response
  else
    json.null!
  end
end

json.responses @response.responses, partial: 'responses/response', as: :response