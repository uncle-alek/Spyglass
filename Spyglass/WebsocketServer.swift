//
//  WebsocketServer.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Foundation
import Vapor

final class WebSocketServer {
    
    let sockets: [(String, (String) -> Void)]
    
    init(
        sockets: [(String, (String) -> Void)]
    ) {
        self.sockets = sockets
    }
       
    func run() {
        var env = try! Environment.detect()
        try! LoggingSystem.bootstrap(from: &env)
        let app = Application(env)
//        app.http.server.configuration.hostname = getIPAddress()!
        app.http.server.configuration.port = 3002
        defer { app.shutdown() }
        sockets.forEach { (socketName: String, callback: @escaping (String) -> Void) in
            app.webSocket(PathComponent(stringLiteral: socketName)) { req, ws in
                ws.onText { ws, text in
                    callback(text)
                }
                ws.onClose.whenComplete { _ in
                    print("Web socket disconnected from server")
                }
                print("Web socket connected to server")
            }
        }
        try! app.run()
    }
}


func getIPAddress() -> String? {
    var address: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next }
            
            let interface = ptr?.pointee
            let addrFamily = interface?.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name: String = String(cString: (interface?.ifa_name)!)
                if name == "en0" {
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
    }
    return address
}
