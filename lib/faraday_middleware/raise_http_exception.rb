require 'faraday'

module FaradayMiddleware
  class RaiseHttpException < Faraday::Middleware
    def call(env)
      @app.call(env).on_complete do |response|
        case response[:status].to_i
        when 400
          raise XenditApi::BadRequest, error_message_400(response)
        when 401
          raise XenditApi::Unauthorized, error_message_400(response)
        when 403
          raise XenditApi::Forbidden, error_message_400(response)          
        when 404
          raise XenditApi::NotFound, error_message_400(response)
        when 500
          raise XenditApi::InternalServerError, error_message_500(response, "Something is technically wrong.")
        when 502
          raise XenditApi::BadGateway, error_message_500(response, "The server returned an invalid or incomplete response.")
        when 504
          raise XenditApi::GatewayTimeout, error_message_500(response, "504 Gateway Time-out")
        end
      end
    end

    def initialize(app)
      super app
      @parser = nil
    end

    private

    def error_message_400(response)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{response[:status]} | #{error_body(response[:body])}"
    end

    def error_body(body)
      # body gets passed as a string, not sure if it is passed as something else from other spots?
      if not body.nil? and not body.empty? and body.kind_of?(String)
        # removed multi_json thanks to wesnolte's commit
        body = ::JSON.parse(body)
      end

      if body.nil?
        nil
      else
        errors = body["errors"]
        return nil if errors.count.zero?

        errors.map { |x| x["messages"] }.join(',')
      end
    end

    def error_message_500(response, body=nil)
      "#{response[:method].to_s.upcase} #{response[:url].to_s}: #{[response[:status].to_s + ':', body].compact.join(' ')}"
    end
  end
end