# Описание
Расширенный responder для контроллеров Rails.
Автоматически создаёт и переводит flash сообщения.

Больше не нужно писать:

    if @entity.update_attributes param[ :entity ]
      flash[ :notice ] = "success"
    end