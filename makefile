.PHONY: help lint pretty stable clean build buildx run

help: ## show this help.
	@egrep '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

lint: ##test files for syntax errors
	yamllint . || true
	mdl . || true
	hadolint build/Dockerfile || true

pretty: ##correct formatting errors
	prettier --parser=markdown --write '*.md' '**/*.md' || true
	prettier --parser=yaml --write '*.y*ml' '**/*.y*ml' || true

stable:
	curl -sL https://formulae.brew.sh/api/cask/folding-at-home.json | jq -r ".version" > build/.version
	cat build/.version

clean: ## clean
	docker system prune -a
	docker images -f dangling=true

build: ## build locally
	docker buildx build \
		--progress=plain \
		--load \
		--platform linux/amd64 \
		--target mini \
		--tag "stefancrain/folding-at-home-mini:local" \
		-f ./build/Dockerfile \
		./build/
	docker buildx build \
		--progress=plain \
		--load \
		--platform linux/amd64 \
		--tag "stefancrain/folding-at-home:local" \
		-f ./build/Dockerfile \
		./build/
	docker images stefancrain/folding-at-home-mini
	docker images stefancrain/folding-at-home

buildx: ## buildx test
	docker buildx build \
		--progress=plain \
		--platform linux/amd64,linux/arm64  \
		--target mini \
		--tag "stefancrain/folding-at-home-mini:local" \
		-f ./build/Dockerfile \
		./build/


run: ## run locally
	docker run -exec -it --rm --entrypoint="/bin/FAHClient" "stefancrain/folding-at-home-mini:local" --info
	docker run -exec -it --rm --entrypoint="/bin/FAHClient" "stefancrain/folding-at-home:local" --info
