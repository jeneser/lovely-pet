TEMPLATE_DIR := templates/macos-desktop-pet
PET_MANIFEST := $(TEMPLATE_DIR)/Sources/LovelyPetApp/Resources/pets/default/pet.json

.PHONY: validate build run package xcode

validate:
	python3 pipeline/scripts/validate-pet-manifest.py $(PET_MANIFEST)

build: validate
	cd $(TEMPLATE_DIR) && swift build

run: validate
	cd $(TEMPLATE_DIR) && swift run LovelyPetApp

package: validate
	cd $(TEMPLATE_DIR) && sh scripts/package-app.sh

xcode:
	sh scripts/open-xcode.sh
