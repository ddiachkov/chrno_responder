# Описание
Расширенный responder для контроллеров Rails.

Фичи:

  - Автоматически создаёт и переводит flash сообщения.

    Больше нет необходимости каждый раз писать:

        if @entity.update_attributes param[ :entity ]
          flash[ :notice ] = "success"
        end

  - Позволяет удалённо валидировать форму на сервере.