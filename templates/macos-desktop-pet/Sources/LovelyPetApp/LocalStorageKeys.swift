import Foundation

enum LocalStorageKeys {
    static let affection = "lovelyPet.app.affection"
    static let scale = "lovelyPet.app.scale"
    static let windowX = "lovelyPet.app.window.x"
    static let windowY = "lovelyPet.app.window.y"
}

extension Notification.Name {
    static let lovelyPetResetLocalData = Notification.Name("lovelyPet.resetLocalData")
}
