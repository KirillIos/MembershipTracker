import SwiftUI

struct LocalStorage {
    static let shared = LocalStorage()
    
    @AppStorage("APP_LINK") var savedLink = ""
    @AppStorage("FIRST_LAUNCH") var isFirstLaunch = true
}

enum ViewState: Equatable {
    case main, service
}

