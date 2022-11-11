import Combine
import Foundation

struct LensConfiguration {
    var isMusicOn: Bool
    
    static let `default` = LensConfiguration(isMusicOn: true)
}

final class LensViewStore: ObservableObject {
    
    @Published var tableView: LensView.TableView = .default
    @Published var tabView: LensView.TabView = .default
    @Published var sharingData: String? = nil
    @Published var configuration: LensConfiguration = .default
    @Published var error: LensError? = nil
    var select: (UUID) -> Void = {_ in }
    var navigateTo: (UUID) -> Void = {_ in }
    var reset: () -> Void = {}
    var rewrite: (String) -> Void = {_ in }
}

final class SpyglassViewStore: ObservableObject {
    
    @Published var ipAddress: String? = nil
    @Published var isLocalHost: Bool = false
    var applicationIsReady: () -> Void = {}
    var updateIp: (IPAddress) -> Void = {_ in }
}
