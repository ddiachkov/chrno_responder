# encoding: utf-8
require "active_support/concern"

module ChrnoResponder
  module Behavior

    ##
    # Модуль добавляет локализацию flash-сообщений.
    #
    module TranslateFlash
      extend ActiveSupport::Concern

      included do
        delegate :flash, :to => :controller
        alias_method_chain :to_html, :flash_translating
      end

      ##
      # Метод локализует flash-сообщения.
      #
      def to_html_with_flash_translating
        # Переводим все сообщения являющиеся символами
        flash.keys.select { |key| flash[ key ].is_a? Symbol }.each do |key|
          flash[ key ] = translate_flash_message flash[ key ]
        end

        to_html_without_flash_translating
      end

      private

      ##
      # Метод локализует значение value.
      #
      def translate_flash_message( value )
        # Получаем ключ локализации для контроллера
        # MyApp::BannersController -> my_app.banner
        controller_i18n_scope = controller.controller_path.split( "/" ).map( &:singularize ).join( "." )

        # Получаем название действия и статус
        # "create.success" -> action_name = "create", status = "success"
        action_name, status = *value.to_s.split( "." )

        # Формируем массив из возможных переводов
        translation_keys = []

        # banners.flash.create.success
        translation_keys << :"#{controller_i18n_scope}.flash.#{action_name}.#{status}"

        # common.flash.create.success
        translation_keys << :"common.flash.#{action_name}.#{status}"

        # flash.create.success
        translation_keys << :"flash.#{action_name}.#{status}"

        # banners.flash.success
        translation_keys << :"#{controller_i18n_scope}.flash.#{status}"

        # common.flash.success
        translation_keys << :"common.flash.#{status}"

        # flash.success
        translation_keys << :"flash.#{status}"

        # Локализуем
        model_name =
          case resource
            when ActiveRecord::Relation
              resource.klass.model_name
            when Array
              resource.first.class.try :model_name
            else
              resource.class.try :model_name
          end

        resource_name = model_name ? model_name.human : "unknown resource"

        ::I18n.t translation_keys.shift, default: [ *translation_keys, value.to_s ], resource: resource_name
      end
    end
  end
end