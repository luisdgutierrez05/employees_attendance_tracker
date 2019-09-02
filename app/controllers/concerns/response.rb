# frozen_string_literal: true

# Handles json response.
module Response
  # Renders a json response from request.
  # @params object [Hash] hash with object information.
  # @params status [Symbol] status of request. By default is :ok
  # @params meta [Hash] meta information of request. By default is nil.
  def json_response(object, status = :ok, meta = nil)
    render json: object, meta: meta, status: status
  end
end
