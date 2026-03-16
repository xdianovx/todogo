include .env
export PROJECT_ROOT=$(shell pwd)
env-up:
	docker compose up -d

env-down:
	docker compose down

env-cleanup:
	@read -p "Опасно, точно? [y/N] " ans; \
	if [ "$$ans" = "y" ]; then \
		docker compose down && \
		rm -rf out; \
		echo "Осторожно, удалены все данные!"; \
	else \
		echo "Отмена удаления данных."; \
	fi

migrate-create:
	@if [ -z "$(seq)" ]; then \
		echo "Ошибка: Не указано имя миграции. Используйте 'make migrate-create seq=имя_миграции'"; \
		exit 1; \
	else \
			docker compose run --rm todo-postgres-migrate \
			create \
				-ext sql \
				-dir /migrations \
			  -seq "$(seq)"; \
	fi	


migrate-force:
	@docker compose run --rm todo-postgres-migrate \
		-path /migrations \
		-database "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@todo-postgres:5432/${POSTGRES_DB}?sslmode=disable" \
		force 0

migrate-up:
	@make migrate-action action=up
	
migrate-down:
	@make migrate-action action=down


migrate-action:
	@if [ -z "$(action)" ]; then \
		echo "Ошибка: Не указано действие. Используйте 'make migrate-action action=up' или 'make migrate-action action=down'"; \
		exit 1; \
	fi

	@docker compose run --rm todo-postgres-migrate \
		-path /migrations \
		-database "postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@todo-postgres:5432/${POSTGRES_DB}?sslmode=disable" \
		"$(action)"

env-port-forward:
	@docker compose up -d port-forward

env-port-close: 
	@docker compose down port-forward