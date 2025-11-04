.PHONY: build run stop clean shell logs

build:
	docker compose build

run:
	docker compose up -d

stop:
	docker compose down

clean:
	docker compose down -v
	docker system prune -f

shell:
	docker compose exec deepspeed-training /bin/bash

logs:
	docker compose logs -f
