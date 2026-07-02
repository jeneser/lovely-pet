# Getting Started

Use `make validate` before running or packaging the macOS template.

Use `make run` to launch the sample locally, `make xcode` to open the Swift package in Xcode, and `make package` to build the app bundle.

The included sample uses the `imageAssets` renderer and transparent PNG frame sequences declared in `pet.json`.

To customize the sample, edit `templates/macos-desktop-pet/Sources/LovelyPetApp/Resources/pets/default/pet.json`, update the PNG frame references, and run `make validate` again.
