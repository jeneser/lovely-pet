TEMPLATE_DIR := templates/macos-desktop-pet
PET_MANIFEST := $(TEMPLATE_DIR)/Sources/LovelyPetApp/Resources/pets/default/pet.json

.PHONY: validate build run

validate:
	python3 pipeline/scripts/validate-pet-manifest.py $(PET_MANIFEST)

build: validate
	cd $(TEMPLATE_DIR) && swift build

run: validate
	cd $(TEMPLATE_DIR) && swift run LovelyPetApp
