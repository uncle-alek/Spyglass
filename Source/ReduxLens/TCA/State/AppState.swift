import Foundation

struct AppState {
    var events: [ReduxEvent] = []
    var selectedItem: ReduxEvent? = nil
    var error: ReduxError?
}

extension AppState {
    func event(id: String) -> ReduxEvent? {
        events.first { $0.id == id }
    }
}
