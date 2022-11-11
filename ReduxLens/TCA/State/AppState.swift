import Foundation
import OrderedCollections

struct AppState {
    var events: OrderedDictionary<UUID, ReduxEvent> = [:]
    var selectedItem: ReduxEvent? = nil
    var error: ReduxError?
}
