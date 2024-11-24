IMAGE = glove80-zmk-config-docker
BRANCH ?= main
USER = $(shell whoami)
MOUNT_FOLDER = /run/media/$(USER)
MOUNT_FOLDER_R = $(MOUNT_FOLDER)/GLV80RHBOOT
MOUNT_FOLDER_L = $(MOUNT_FOLDER)/GLV80LHBOOT

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

flash: $(firmware)
	@echo -n "Plug in right half and enter flash mode"
	@while [ ! -d "$(MOUNT_FOLDER_R)" ]; do sleep 1; echo -n '.'; done
	@echo
	cp $(firmware) "$(MOUNT_FOLDER_R)"
	@echo -n "Plug in left half and enter flash mode"
	@while [ ! -d "$(MOUNT_FOLDER_L)" ]; do sleep 1; echo -n '.'; done
	@echo
	cp $(firmware) "$(MOUNT_FOLDER_L)"
	@echo "Flashing firmware done"

clean:
	rm -f $(firmware) $(keymap) $(svg)

.PHONY: clean
