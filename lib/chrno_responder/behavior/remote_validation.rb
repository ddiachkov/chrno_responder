# encoding: utf-8
require "active_support/concern"

module ChrnoResponder
  module Behavior

    ##
    # Модуль добавляет возможность серверной валидации для remote-форм.
    #
    module RemoteValidation
      extend ActiveSupport::Concern

      included do
        delegate :params, :to => :request

        alias_method :to_json, :to_format unless method_defined? :to_json
        alias_method_chain :to_json, :remote_validation
      end

      def to_json_with_remote_validation
        if has_errors? and client_expects_validation?
          send_errors_as_json!
        else
          to_json_without_remote_validation
        end
      end

      private

      ##
      # Клиент ожидает валидацию?
      #
      def client_expects_validation?
        ( post? or put? ) and ( params[ :validate ] == "true" or request.headers[ "HTTP_REMOTE_VALIDATION" ] == "true" )
      end

      ##
      # Посылает JSON с ошибками.
      #
      def send_errors_as_json!
        render json: serialize_errors, status: :conflict, content_type: "application/json"
      end

      ##
      # Трансформирует ошибки ресурса в JSON вида: { модель: { поле: [ список_ошибок ] }}
      #
      def serialize_errors
        { resource.class.model_name.underscore => resource.errors.to_hash }.to_json
      end
    end
  end
end