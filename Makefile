TEMPLATE_DIR := templates/macos-desktop-pet
PET_MANIFEST := $(TEMPLATE_DIR)/Sources/LovelyPetApp/Resources/pets/default/pet.json
COMPAT_REPORT := $(TEMPLATE_DIR)/dist/macos-compatibility-report.md

.PHONY: validate compat build run package xcode

validate:
	python3 pipeline/scripts/validate-pet-manifest.py $(PET_MANIFEST)

compat:
	python3 pipeline/scripts/validate-macos-compatibility.py --report $(COMPAT_REPORT)

build: validate compat
	cd $(TEMPLATE_DIR) && swift build

run: validate compat
	cd $(TEMPLATE_DIR) && swift run LovelyPetApp

package: validate compat
	cd $(TEMPLATE_DIR) && sh scripts/package-app.sh

xcode:
	sh scripts/open-xcode.sh
