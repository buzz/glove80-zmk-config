IMAGE = glove80-zmk-config-docker
BRANCH ?= main

firmware = glove80.uf2

all: $(firmware)

$(firmware): Dockerfile config/glove80.conf config/glove80.keymap config/default.nix
	docker build -t $(IMAGE) --progress=plain .
	docker run --rm -v "$(CURDIR):/config" -e UID=$(shell id -u) -e GID=$(shell id -g) -e BRANCH=$(BRANCH) $(IMAGE)

clean:
	rm $(firmware)

.PHONY: clean
