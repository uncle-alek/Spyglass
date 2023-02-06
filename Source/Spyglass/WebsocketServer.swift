import Foundation
import Vapor

typealias Callback = (String) -> Void
typealias Connector = (@escaping (String) -> Void) -> Void

final class WebSocketServer {
    
    /// Vapor frame size is limited to UInt32.max
    private static let maxFrameSize = WebSocketMaxFrameSize(integerLiteral: Int(UInt32.max))
    private let app: Application
    
    static var ipAddress: String? { Network.ipAddress }
    
    init(
        isLocalHost: Bool,
        sockets: [(String, Callback, Connector)]
    ) {
        self.app = WebSocketServer.application(isLocalHost, sockets)
    }
       
    func run() {
        try! app.run()
    }
    
    func shutdown() {
        app.shutdown()
    }
}

extension WebSocketServer {
    
    static func application(
        _ isLocalHost: Bool,
        _ sockets: [(String, Callback, Connector)]
    ) -> Application {
        let app = Application(try! Environment.detect())
        app.http.server.configuration.port = 3002
        if !isLocalHost, let ipAddress = ipAddress { app.http.server.configuration.hostname = ipAddress }
        sockets.forEach { (socketName: String, callback: @escaping Callback, connector: @escaping Connector) in
            app.webSocket(PathComponent(stringLiteral: socketName), maxFrameSize: WebSocketServer.maxFrameSize) { req, ws in
                ws.onText { ws, text in
                    DispatchQueue.main.async {
                        callback(text)
                    }
                }
                connector { text in
                    ws.send(text)
                }
                ws.onClose.whenComplete { _ in
                    print("Web socket disconnected from server")
                }
                print("Web socket connected to server")
            }
        }
        return app
    }
}
