//
//  Reducer.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import ComposableArchitecture
import Foundation

let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .setup:
        return .none
    case .reset:
        state.events = []
        return .none
    case .receive(let value):
        let action = ReduxEvent(utf8: value)
        state.events.append((UUID(), action))
        return .none
    case .selectItem(id: let id):
        state.selectedItem = state.events.first(where: { $0.0 == id })?.1
        return .none
    case .navigateToItem(id: let id):
        guard let event = state.events.first(where: { $0.0 == id }),
              let file = event.1.file,
              let line = event.1.line
        else { return .none }
        
        return .fireAndForget {
            _ = environment.shell("xed", "-x", file)
            _ = environment.shell("xed", "-x", "-l", String(line))
        }
    }
}

extension ReduxEvent {
    
    init(utf8: String) {
        let data = utf8.data(using: .utf8)!
        self = try! JSONDecoder().decode(ReduxEvent.self, from: data)
    }
}
