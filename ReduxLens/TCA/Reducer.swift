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
        state.selectedItem = nil
        return .none
    case .receive(let value):
        switch ReduxEvent.event(from: value) {
            case .success(let event):
                state.events.append((UUID(), event))
            case .failure(let decodingError):
                state.error = .eventNotDeserialiazable(decodingError)
        }
        return .none
    case .selectItem(id: let id):
        state.selectedItem = state.events.first(where: { $0.0 == id })?.1
        return .none
    case .navigateToItem(id: let id):
        guard let event = state.events.first(where: { $0.0 == id }) else { return .none }
        guard let file = event.1.file else { state.error = .navigationFailedFileNotFound; return .none }
        guard let line = event.1.line else { state.error = .navigationFailedLineNotFound; return .none }
        
        return .fireAndForget {
            _ = environment.shell("xed", "-x", file)
            _ = environment.shell("xed", "-x", "-l", String(line))
        }
    }
}

extension ReduxEvent {
    
    static func event(from string: String) -> Result<ReduxEvent, DecodingError> {
        let data = string.data(using: .utf8)!
        do {
            return .success(try JSONDecoder().decode(ReduxEvent.self, from: data))
        } catch {
            return .failure(error as! DecodingError)
        }
    }
}
