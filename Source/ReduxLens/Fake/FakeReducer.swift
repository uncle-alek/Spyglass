import ComposableArchitecture
import Foundation

let appReducer_fake = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .setup:
        let fakeState = loadBigStateJson()
        state.events = [ReduxEvent(fakeState, fakeState)]
        state.error = .navigationFailedLineNotFound
        return .none
    case .selectItem(id: let id):
        let fakeState = loadBigStateJson()
        state.selectedItem = ReduxEvent(fakeState, fakeState)
        return .none
    case .reset,
         .receive(_),
         .navigateToItem(_):
        return .none
    }
}

extension ReduxEvent {
    
    init(
        _ stateBefore: [String: Any],
        _ stateAfter: [String: Any]
    ) {
        self.id = UUID().uuidString
        self.name = "Test action"
        self.timeStamp = Date().timeIntervalSince1970
        self.leadTime = Date().timeIntervalSince1970
        self.stateBefore = stateBefore
        self.stateAfter = stateAfter
        self.file = nil
        self.line = nil
    }
}
