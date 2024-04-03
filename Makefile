ifneq (,$(wildcard ./config/.env))
    include ./config/.env
    export
endif

ENV?=local
DIRNAME=`basename ${PWD}`
PG_EXEC=psql "host=$(POSTGRES_HOST) port=$(POSTGRES_PORT) user=$(POSTGRES_USER) password=$(POSTGRES_PASSWORD) gssencmode='disable'

cmd-exists-%:
	@hash $(*) > /dev/null 2>&1 || \
		(echo "ERROR: '$(*)' must be installed and available on your PATH."; exit 1)

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/[:].*[##]/:/'

start-localstack: ## Start the Docker container services
	docker-compose --env-file ./config/.env up -d

stop-localstack: ## Stop the Docker container services
	docker-compose down

build-scaffold: 
	cd ./local_scaffold; tflocal init; tflocal apply -auto-approve

destroy-scaffold: 
	cd ./local_scaffold; tflocal init; tflocal destroy -auto-approve

test: ## Test python
	cd src; pytest --continue-on-collection-errors -rPp --cov=. --cov-report term-missing

rebuild-localstack: ## Rebuild localstack implementation
	docker-compose down
	docker-compose --env-file ./config/.env up -d
	samlocal build
	samlocal deploy --stack-name samapp