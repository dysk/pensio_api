module PensioAPI
  module Responses
    class Base
      include PensioAPI::Mixins::MethodMissing

      attr_reader :raw

      def initialize(request)
        @raw = request.body
        @headers = request.headers
        unless success?
          raise PensioAPI::Errors::BadRequest.new(request) unless header_ok
          raise PensioAPI::Errors::GatewayError.new(request) unless body_ok
        end
      end

      def success?
        header_ok && body_ok
      end

      private

      def header_ok
        @headers['ErrorCode'].to_i == 0
      end

      def body_ok
        !@raw.has_key?('Result') || ['Success', 'OK', nil].include?(@raw['Result'])
      end
    end
  end
end