.PHONY: help lint pretty buildx run-local

help: ## show this help.
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'


lint: ##test files for syntax errors
	yamllint . || true
	markdownlint . || true
	hadolint build/Dockerfile || true

pretty: ##correct formatting errors
	prettier --parser=markdown --write '*.md' '**/*.md' || true
	prettier --parser=yaml --write '*.y*ml' '**/*.y*ml' || true

buildx: ## build locally
	make pretty
	make lint
	docker buildx build --load --platform linux/amd64 --build-arg=VERSION=7.6.9 --build-arg=VERSION_MAJOR=7.6 --build-arg=VCS_REF=1 --build-arg=BUILD_DATE=1 --tag "stefancrain/folding-at-home:local" -f ./build/Dockerfile ./build/

run-local: ## test locally
	docker run "stefancrain/folding-at-home:local"
