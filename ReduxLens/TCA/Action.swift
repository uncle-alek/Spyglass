import Foundation

enum AppAction: Equatable {
    case setup
    case reset
    case receive(_ value: String)
    case selectItem(id: UUID)
    case navigateToItem(id: UUID)
}
