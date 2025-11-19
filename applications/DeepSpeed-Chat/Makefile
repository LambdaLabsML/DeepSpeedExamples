.PHONY: env build run stop clean shell logs

env:
	./docker_scripts/make_env.sh

build:
	./docker_scripts/make_build.sh

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
