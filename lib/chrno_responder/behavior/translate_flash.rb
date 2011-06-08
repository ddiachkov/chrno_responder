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

        # Формируем массив из возможных переводов
        translation_keys = []

        # banners.flash.create.success
        translation_keys << :"#{controller_i18n_scope}.flash.#{controller.action_name}.#{value}"

        # banners.flash.success
        translation_keys << :"#{controller_i18n_scope}.flash.#{value}"

        # common.flash.create.success
        translation_keys << :"common.flash.#{controller.action_name}.#{value}"

        # common.flash.success
        translation_keys << :"common.flash.#{value}"

        # flash.create.success
        translation_keys << :"flash.#{controller.action_name}.#{value}"

        # flash.success
        translation_keys << :"flash.#{value}"

        # Локализуем
        resource_name =
          case resource
            when ActiveRecord::Relation
              resource.klass.model_name.human
            when Array
              resource.first.class.model_name.human
            else
              resource.class.model_name.human.pluralize
          end

        ::I18n.t translation_keys.shift, default: [ *translation_keys, value.to_s ], resource: resource_name
      end
    end
  end
end