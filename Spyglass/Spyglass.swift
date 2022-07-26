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
    static var cancellable: AnyCancellable?
        
    static func run() {
                
        cancellable = lens.viewPublisher.sink { tableView in
            DispatchQueue.main.async {
                viewStore.tableView = tableView
            }
        }
        
        lens.setup()
        
        let webSocket = WebSocketServer(
            sockets: [
                (lens.connectionPath, lens.loop(with:))
            ]
        )
        
        DispatchQueue.global(qos: .background).async {
            webSocket.run()
        }
    }
}

final class ViewStore: ObservableObject {
    
    @Published var tableView: TableView4 = .default
}
