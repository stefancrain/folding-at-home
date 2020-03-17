.PHONY: help

help: ##show this help.
	@IFS=$$'\n' ; \
	help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##/:/'`); \
	printf "%-30s %s\n" "target" "help" ; \
	printf "%-30s %s\n" "------" "----" ; \
	for help_line in $${help_lines[@]}; do \
			IFS=$$':' ; \
			help_split=($$help_line) ; \
			help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			help_info=`echo $${help_split[2]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
			printf '\033[36m'; \
			printf "%-30s %s" $$help_command ; \
			printf '\033[0m'; \
			printf "%s\n" $$help_info; \
	done

lint: ##test files for syntax errors
	yamllint . || true
	markdownlint . || true 
	hadolint build/Dockerfile || true 
	hadolint build/Dockerfile-cuda || true 

pretty: ##correct formatting errors
	prettier --parser=markdown --write '*.md' '**/*.md' || true
	prettier --parser=yaml --write '*.y*ml' '**/*.y*ml' || true

buildx: ## build locally
	docker buildx build --platform linux/amd64 --build-arg=VERSION=7.5.1 --build-arg=VERSION_MAJOR=7.5 --tag "stefancrain/folding-at-home:local-cuda" -f ./build/Dockerfile-cuda ./build/
	docker buildx build --platform linux/amd64,linux/arm64 --build-arg=VERSION=7.5.1 --build-arg=VERSION_MAJOR=7.5 --tag "stefancrain/folding-at-home:local" -f ./build/Dockerfile ./build/

run-local: ## test locally
	docker run "stefancrain/folding-at-home:local"

run-cuda: ## test locally
	docker run "stefancrain/folding-at-home:local-cuda"

