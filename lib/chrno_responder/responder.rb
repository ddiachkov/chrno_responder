# encoding: utf-8
require "active_support/dependencies/autoload"
require "action_controller/metal/responder"

module ChrnoResponder
  # Расширения для респондера
  module Behavior
    extend ActiveSupport::Autoload

    autoload :AutoFlash,      "chrno_responder/behavior/auto_flash"
    autoload :TranslateFlash, "chrno_responder/behavior/translate_flash"
  end

  ##
  # Кастомный респондер для контроллеров.
  #
  class Responder < ActionController::Responder
    # Добавляем расширения
    include ChrnoResponder::Behavior::AutoFlash
    include ChrnoResponder::Behavior::TranslateFlash
  end
end