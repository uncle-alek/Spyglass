//
//  Spyglass.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Combine
import Foundation

final class Spyglass {
        
    static let lens = TAGALensBuilder().build()
    static let viewStore = ViewStore()
    static var tableCancellable: AnyCancellable?
    static var tabCancellable: AnyCancellable?

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
        viewStore.select = { $0.map(lens.selectItem(with:)) } 
        
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
    var select: (UUID?) -> Void = {_ in }
}
