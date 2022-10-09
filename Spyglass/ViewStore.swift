//
//  ViewStore.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 9/10/22.
//

import Combine
import Foundation

final class LensViewStore: ObservableObject {
    
    @Published var tableView: LensView.TableView = .default
    @Published var tabView: LensView.TabView = .default
    @Published var sharingData: String? = nil
    var select: (UUID) -> Void = {_ in }
    var navigateTo: (UUID) -> Void = {_ in }
    var reset: () -> Void = {}
    var rewrite: (String) -> Void = {_ in }
}

final class SpyglassViewStore: ObservableObject {
    
    @Published var ipAddress: String = ""
    @Published var isLocalHost: Bool = false
    var applicationIsReady: () -> Void = {}
    var updateIp: (IPAddress) -> Void = {_ in }
}