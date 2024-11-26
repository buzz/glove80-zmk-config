IMAGE = glove80-zmk-config-docker
BRANCH ?= main
USER = $(shell whoami)
MOUNT_FOLDER = /run/media/$(USER)
MOUNT_FOLDER_R = $(MOUNT_FOLDER)/GLV80RHBOOT
MOUNT_FOLDER_L = $(MOUNT_FOLDER)/GLV80LHBOOT
VENV = .venv/touchfile
KEYMAP_CONFIG = keymap_drawer_config.yaml
GLOVE_KEYMAP = config/glove80.keymap

firmware = glove80.uf2
keymap = keymap.yaml
svg = keymap.svg

all: $(firmware) $(svg)

$(firmware): $(GLOVE_KEYMAP) Dockerfile config/glove80.conf config/default.nix
	docker build -t $(IMAGE) --progress=plain .
	docker run --rm -v "$(CURDIR):/config" -e UID=$(shell id -u) -e GID=$(shell id -g) -e BRANCH=$(BRANCH) $(IMAGE)

$(keymap): $(KEYMAP_CONFIG) $(GLOVE_KEYMAP) $(VENV)
	. .venv/bin/activate; keymap -c $(KEYMAP_CONFIG) parse -z $(GLOVE_KEYMAP) -l Base Lower Symbols World Gaming Magic -o $@

$(svg): $(KEYMAP_CONFIG) $(keymap) $(VENV)
	. .venv/bin/activate; keymap -c $(KEYMAP_CONFIG) draw $(keymap) >$@

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

$(VENV): requirements.txt
	test -d .venv || python -m venv .venv
	. .venv/bin/activate; pip install -U pip && pip install -Ur requirements.txt
	touch $(VENV)

clean:
	rm -f $(firmware) $(keymap) $(svg)

.PHONY: clean flash
