import ComposableArchitecture
import Foundation

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .setup:
        return .none
    case .reset:
        state.events = [:]
        state.selectedItem = nil
        return .none
    case .receive(let value):
        switch ReduxEvent.event(from: value) {
            case .success(let event):
                state.events[UUID()] = event
            case .failure(let decodingError):
                state.error = .eventNotDeserialiazable(decodingError)
        }
        return .none
    case .selectItem(id: let id):
        state.selectedItem = state.events[id]
        return .none
    case .navigateToItem(id: let id):
        guard let file = state.events[id]?.file else { state.error = .navigationFailedFileNotFound; return .none }
        guard let line = state.events[id]?.line else { state.error = .navigationFailedLineNotFound; return .none }
        
        return .fireAndForget {
            _ = environment.shell("xed", "-x", file)
            _ = environment.shell("xed", "-x", "-l", String(line))
        }
    }
}
