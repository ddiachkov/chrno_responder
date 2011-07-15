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
        alias_method :to_js, :to_format unless method_defined? :to_js
        alias_method_chain :to_js, :remote_validation
      end

      ##
      # Посылает JSON с ошибками (или в случае их отсутствия -- с самим ресурсом).
      #
      def to_js_with_remote_validation
        # Проверяем, что действие пришло от формы
        if post? and params.include? :commit
          # Были ли ошибки?
          if has_errors?
            render json: serialize_errors, status: :conflict, content_type: "application/json"
          else
            # Ошибок нет, просто возвращаем 200 статус и сам ресурс
            render json: resource.to_json, status: :ok, content_type: "application/json"
          end
        else
          to_js_without_remote_validation
        end
      end

      private

      ##
      # Трансформирует ошибки ресурса в JSON вида: { модель: { поле: [ список_ошибок ] }}
      #
      def serialize_errors
        { resource.class.model_name.underscore => resource.errors.to_hash }.to_json
      end
    end
  end
end