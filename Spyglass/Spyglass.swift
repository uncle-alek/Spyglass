//
//  Spyglass.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Combine
import Foundation

final class Spyglass {
        
    static let lens = ReduxLensBuilder().build()
    static let viewStore = ViewStore()
    static var tableCancellable: AnyCancellable?
    static var tabCancellable: AnyCancellable?
    static var sharedItemsCancellable: AnyCancellable?

    static func run() {
                
        tableCancellable = lens.tablePublisher.sink { tableView in
            DispatchQueue.main.async {
                viewStore.tableView = tableView
            }
        }
        tabCancellable = lens.tabPublisher.sink { tabView in
            DispatchQueue.main.async {
                viewStore.tabView = tabView
            }
        }
        sharedItemsCancellable = lens.sharingData.sink { data in
            DispatchQueue.main.async {
                viewStore.sharingData = data
            }
        }
        viewStore.select = lens.selectItem(with:)
        viewStore.navigateTo = lens.navigateToItem(with:)
        viewStore.reset = lens.reset
        viewStore.shareHistory = lens.shareHistory
        
        lens.setup()
        
        let webSocket = WebSocketServer(
            sockets: [
                (lens.connectionPath, lens.receive(_:))
            ]
        )
        
        DispatchQueue.global(qos: .background).async {
            webSocket.run()
        }
    }
}

final class ViewStore: ObservableObject {
    
    @Published var tableView: LensView.TableView = .default
    @Published var tabView: LensView.TabView = .default
    @Published var sharingData: String? = nil
    var select: (UUID) -> Void = {_ in }
    var navigateTo: (UUID) -> Void = {_ in }
    var reset: () -> Void = {}
    var shareHistory: () -> Void = {}
}
