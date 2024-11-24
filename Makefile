IMAGE = glove80-zmk-config-docker
BRANCH ?= main

firmware = glove80.uf2
keymap = keymap.yaml
svg = keymap.svg

all: $(firmware) $(svg)

$(firmware): Dockerfile config/glove80.conf config/glove80.keymap config/default.nix
	docker build -t $(IMAGE) --progress=plain .
	docker run --rm -v "$(CURDIR):/config" -e UID=$(shell id -u) -e GID=$(shell id -g) -e BRANCH=$(BRANCH) $(IMAGE)

$(keymap): config/glove80.keymap
	# keymap parse -c 10 -z $< -o $@
	keymap parse -z $< -o $@

$(svg): $(keymap)
	keymap draw $< >$@

clean:
	rm -f $(firmware) $(keymap) $(svg)

.PHONY: clean
