import Foundation

enum LocalStorageKeys {
    static let affection = "lovelyPet.demo.affection"
    static let scale = "lovelyPet.demo.scale"
    static let windowX = "lovelyPet.demo.window.x"
    static let windowY = "lovelyPet.demo.window.y"
}

extension Notification.Name {
    static let lovelyPetResetLocalData = Notification.Name("lovelyPet.resetLocalData")
}
