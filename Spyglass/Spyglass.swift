//
//  Spyglass.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Foundation

final class Spyglass {
        
    static func run() {
        let webSocket = WebSocketServer(
            sockets: [
                ("echo", { print($0) })
            ]
        )
        
        DispatchQueue.global(qos: .background).async {
            webSocket.run()
        }
    }
}
