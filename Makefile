REPO			= docker.io
IMG_NAME		= yidigun/nexus3

IMG_TAG			= $(TAG)
PUSH			= yes
BUILDER			= crossbuilder
PLATFORM		= linux/amd64,linux/arm64

.PHONEY: $(DOCKER_BUILDER) $(TAG) all

all:
	@if [ -z "$(TAG)" ]; then \
	  echo "usage: make TAG=tagname [ BUILD_ARGS=\"NAME=value NAME=value ...\" ] [ PUSH=no ]" >&2; \
	else \
	  $(MAKE) $(TAG); \
	fi

$(TAG): $(BUILDER)
	@BUILD_ARGS=; \
	PUSH=; \
	for a in $(BUILD_ARGS); do \
	  BUILD_ARGS="$$BUILD_ARGS --build-arg \"$$a\""; \
	done; \
	if [ "$(PUSH)" = "yes" ]; then \
	  PUSH="--push"; \
	fi; \
	CMD="docker buildx build \
	    --builder $(BUILDER) --platform "$(PLATFORM)" \
	    --build-arg IMG_NAME=$(IMG_NAME) --build-arg IMG_TAG=$(IMG_TAG) \
	    $$BUILD_ARGS $$PUSH \
	    -t $(REPO)/$(IMG_NAME):latest \
	    -t $(REPO)/$(IMG_NAME):$(IMG_TAG) \
	    ."; \
	echo $$CMD; \
	eval $$CMD

$(BUILDER):
	@if docker buildx ls | grep -q ^$(BULDER); then \
	  : do nothing; \
	else \
	  CMD="docker buildx create --name $(BUILDER) \
	    --driver docker-container"; \
	    --platform \"$(PLATFORM)\" \
	  echo $$CMD; \
	  eval $$CMD; \
	fi
