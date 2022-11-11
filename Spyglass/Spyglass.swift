//
//  Spyglass.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Combine
import Foundation

enum IPAddress {
    case local
    case custom
}

final class Spyglass {
        
    static let lens = ReduxLensBuilder().build()
    static let lensViewStore = LensViewStore()
    static let spyglassViewStore = SpyglassViewStore()
    static var webSocketServer: WebSocketServer?
    static var tableCancellable: AnyCancellable?
    static var tabCancellable: AnyCancellable?
    static var sharedItemsCancellable: AnyCancellable?
    static var errorCancellable: AnyCancellable?

    static func setup() {
        setupLensViewStore()
        setupSpyglassViewStore()
        setupLens()
        setupWebSocketServer()
    }

    static func run() {
        runWebSocketServer()
    }
    
    static func updateIp(_ ipAddress: IPAddress) {
        spyglassViewStore.isLocalHost = ipAddress == .local
        
        shutdownWebSocketServer()
        setupWebSocketServer(ipAddress == .local)
        runWebSocketServer()
    }
}

private extension Spyglass {
    
    static func setupLensViewStore() {
        tableCancellable = lens.tablePublisher.sink { tableView in
            DispatchQueue.main.async {
                lensViewStore.tableView = tableView
            }
        }
        tabCancellable = lens.tabPublisher.sink { tabView in
            DispatchQueue.main.async {
                lensViewStore.tabView = tabView
            }
        }
        sharedItemsCancellable = lens.sharingDataPublisher.sink { data in
            DispatchQueue.main.async {
                lensViewStore.sharingData = data
            }
        }
        errorCancellable = lens.errorPublisher.sink { error in
            DispatchQueue.main.async {
                lensViewStore.error = error
            }
        }
        
        lensViewStore.select = lens.selectItem(with:)
        lensViewStore.navigateTo = lens.navigateToItem(with:)
        lensViewStore.reset = lens.reset
        lensViewStore.rewrite = lens.rewrite
    }
    
    static func setupSpyglassViewStore() {
        spyglassViewStore.updateIp = updateIp
        spyglassViewStore.ipAddress = WebSocketServer.ipAddress
        spyglassViewStore.isLocalHost = true
    }
    
    static func setupLens() {
        lens.setup()
    }
    
    static func setupWebSocketServer(_ isLocalHost: Bool = true) {
        webSocketServer = WebSocketServer(
            isLocalHost: isLocalHost,
            sockets: [
                (lens.connectionPath, lens.receive, lens.send)
            ]
        )
    }
    
    static func runWebSocketServer() {
        DispatchQueue.global(qos: .background).async {
            webSocketServer?.run()
        }
    }
    
    static func shutdownWebSocketServer() {
        DispatchQueue.global(qos: .background).async {
            webSocketServer?.shutdown()
        }
    }
}
