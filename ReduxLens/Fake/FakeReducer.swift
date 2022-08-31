//
//  FakeReducer.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import ComposableArchitecture
import Foundation

let appReducer_fake = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .setup:
        let fakeState = loadBigStateJson()
        state.events = [(UUID(), ReduxEvent(fakeState, fakeState))]
        return .none
    case .selectItem(id: let id):
        let fakeState = loadBigStateJson()
        state.selectedItem = ReduxEvent(fakeState, fakeState)
        return .none
    case .reset,
         .receive(_),
         .navigateToItem(_),
         .shareHistory:
        return .none
    }
}

extension ReduxEvent {
    
    init(
        _ stateBefore: [String: Any],
        _ stateAfter: [String: Any]
    ) {
        self.name = "Test action"
        self.timestamp = Date().timeIntervalSince1970
        self.stateBefore = stateBefore
        self.stateAfter = stateAfter
        self.file = nil
        self.line = nil
    }
}
