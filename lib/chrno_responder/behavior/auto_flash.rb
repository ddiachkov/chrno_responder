# encoding: utf-8
require "active_support/concern"

module ChrnoResponder
  module Behavior

    ##
    # Модуль добавляет автоматические flash-сообщения.
    #
    module AutoFlash
      extend ActiveSupport::Concern

      included do
        delegate :flash, :to => :controller
        alias_method_chain :to_html, :auto_flashing
      end

      ##
      # Метод автоматически устанавливает flash-сообщение со статусом post, put
      # и delete действий.
      #
      def to_html_with_auto_flashing
        # Только для не-аяксных post, put и delete
        if not get? and not request.xhr?
          # В зависимости от наличия ошибок, добавляем сообщение :error или :success
          has_errors? \
            ? flash.alert  ||= "#{controller.action_name}.error".to_sym \
            : flash.notice ||= "#{controller.action_name}.success".to_sym
        end

        to_html_without_auto_flashing
      end
    end
  end
end