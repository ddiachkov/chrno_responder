# encoding: utf-8
require "active_support/dependencies/autoload"

module ChrnoResponder
  extend ActiveSupport::Autoload

  autoload :Responder, "chrno_responder/responder"
  autoload :VERSION,   "chrno_responder/version"

  class Railtie < Rails::Railtie
    initializer "chrno_responder.initialize" do
      # Выставляем новый responder по умолчанию
      ActiveSupport.on_load( :after_initialize ) do
        puts "--> load chrno_responder local"
        ActionController::Base.responder = ChrnoResponder::Responder
      end
    end
  end
end