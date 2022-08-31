//
//  TAGALens.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Combine
import ComposableArchitecture
import Foundation

let FAKE = false

final class ReduxLens: Lens {
    var tablePublisher: AnyPublisher<LensView.TableView, Never>
    var tabPublisher: AnyPublisher<LensView.TabView, Never>
    var sharingData: AnyPublisher<String?, Never>
    var connectionPath: String { "redux" }
    
    private static func store() -> Store<AppState, AppAction> {
        Store(
            initialState: AppState(),
            reducer: FAKE ? appReducer_fake : appReducer,
            environment: AppEnvironment(shell: shell)
        )
    }
    private let viewStore: ComposableArchitecture.ViewStore<AppViewState, AppAction> = ComposableArchitecture.ViewStore(
        store().scope(state: AppViewState.init),
        removeDuplicates: ==
    )
    
    init() {
        tablePublisher = viewStore.publisher.tableView.eraseToAnyPublisher()
        tabPublisher = viewStore.publisher.tabView.eraseToAnyPublisher()
        sharingData = viewStore.publisher.sharingHistory.eraseToAnyPublisher()
    }
    
    func setup() {
        DispatchQueue.main.async {
            self.viewStore.send(.setup)
        }
    }
    
    func reset() {
        DispatchQueue.main.async {
            self.viewStore.send(.reset)
        }
    }
    
    func receive(_ value: String) {
        DispatchQueue.main.async {
            self.viewStore.send(.receive(value))
        }
    }
    
    func selectItem(with id: UUID) {
        DispatchQueue.main.async {
            self.viewStore.send(.selectItem(id: id))
        }
    }
    
    func navigateToItem(with id: UUID) {
        DispatchQueue.main.async {
            self.viewStore.send(.navigateToItem(id: id))
        }
    }
    
    func shareHistory() {
        DispatchQueue.main.async {
            self.viewStore.send(.shareHistory)
        }
    }
}
