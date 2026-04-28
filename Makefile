.PHONY: test release changelog

test:
	npm test

VERSION ?=
# Default to patch bumps; set VERSION=x.y.z to override
# Set BUMP=minor or BUMP=major to override bump type
BUMP ?= patch

# Default branch name (change to 'master' if needed)
BRANCH ?= main

release: changelog
	@git fetch --tags origin && \
	if [ -n "$(VERSION)" ]; then TAG=v$(VERSION); \
	else LATEST=$$(git tag -l 'v*' --sort=-v:refname | head -1); \
	  if [ -z "$$LATEST" ]; then TAG=v0.1.0; \
	  else V=$${LATEST#v}; \
	    MAJOR=$${V%%.*}; REST=$${V#*.}; MINOR=$${REST%%.*}; PATCH=$${REST##*.}; \
	    if [ "$(BUMP)" = "major" ]; then TAG=v$$((MAJOR+1)).0.0; \
	    elif [ "$(BUMP)" = "minor" ]; then TAG=v$${MAJOR}.$$((MINOR+1)).0; \
	    else TAG=v$${MAJOR}.$${MINOR}.$$((PATCH+1)); fi; fi; \
	fi && \
	NEW_VERSION=$${TAG#v} && \
	printf "Release $$TAG? [y/N] " && read ans && [ "$$ans" = y ] && \
	npm version $$NEW_VERSION --no-git-tag-version && \
	git add -A && \
	git commit -m "Release $$TAG" && \
	git tag "$$TAG" && \
	echo "" && \
	echo "Release $$TAG created. Push with:" && \
	echo "  git push origin $(BRANCH) && git push origin $$TAG"

# Using claude-sonnet instead of opus for faster/cheaper changelog generation
changelog:
	pi -p --model anthropic/claude-sonnet-4-5 "Update the changelog using the kchangelog skill"
