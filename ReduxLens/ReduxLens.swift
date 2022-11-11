import Combine
import ComposableArchitecture
import Foundation

let FAKE = false

final class ReduxLens: Lens {
    
    var errorPublisher: AnyPublisher<LensError?, Never>
    var tablePublisher: AnyPublisher<LensView.TableView, Never>
    var tabPublisher: AnyPublisher<LensView.TabView, Never>
    var sharingDataPublisher: AnyPublisher<String?, Never>
    var send: ((String) -> Void)!
    var connectionPath: String { "redux" }
    
    private static func store() -> Store<AppState, AppAction> {
        Store(
            initialState: AppState(),
            reducer: FAKE ? appReducer_fake : appReducer,
            environment: appEnvironment
        )
    }
    
    private let viewStore: ComposableArchitecture.ViewStore<AppViewState, AppAction> = ComposableArchitecture.ViewStore(
        store().scope(state: AppViewState.init),
        removeDuplicates: ==
    )
    
    init() {
        errorPublisher = viewStore.publisher.error.eraseToAnyPublisher()
        tablePublisher = viewStore.publisher.tableView.eraseToAnyPublisher()
        tabPublisher = viewStore.publisher.tabView.eraseToAnyPublisher()
        sharingDataPublisher = viewStore.publisher.sharingHistory.eraseToAnyPublisher()
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
    
    func send(_ completion: @escaping (String) -> Void) {
        send = completion
    }
    
    func rewrite(_ value: String) {
        send(value)
    }
}
