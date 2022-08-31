//
//  TAGALens.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Combine
import ComposableArchitecture
import Foundation

final class ReduxLens: Lens {
    var tablePublisher: AnyPublisher<LensView.TableView, Never>
    var tabPublisher: AnyPublisher<LensView.TabView, Never>
    var sharingData: AnyPublisher<String?, Never>
    var connectionPath: String { "redux" }
    
    private static func store() -> Store<AppState, AppAction> {
        Store(initialState: AppState(), reducer: appReducer, environment: AppEnvironment(shell: shell))
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
        viewStore.send(.setup)
    }
    
    func reset() {
        viewStore.send(.reset)
    }
    
    func receive(_ value: String) {
        viewStore.send(.receive(value))
    }
    
    func selectItem(with id: UUID) {
        viewStore.send(.selectItem(id: id))
    }
    
    func navigateToItem(with id: UUID) {
        viewStore.send(.navigateToItem(id: id))
    }
    
    func shareHistory() {
        viewStore.send(.shareHistory)
    }
}
