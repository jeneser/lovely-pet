TEMPLATE_DIR := templates/macos-desktop-pet
PET_MANIFEST := $(TEMPLATE_DIR)/Sources/LovelyPetApp/Resources/pets/ragdoll-demo/pet.json

.PHONY: help validate build run package

help:
	@echo "make validate | build | run | package"

validate:
	python3 pipeline/scripts/validate-pet-manifest.py $(PET_MANIFEST)

build: validate
	cd $(TEMPLATE_DIR) && swift build

run: validate
	cd $(TEMPLATE_DIR) && swift run LovelyPetApp

package: validate
	cd $(TEMPLATE_DIR) && bash scripts/package-app.sh
