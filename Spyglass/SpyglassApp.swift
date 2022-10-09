//
//  SpyglassApp.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import SwiftUI

@main
struct SpyglassApp: App {
    
    @ObservedObject var viewStore = Spyglass.spyglassViewStore
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear { NSWindow.allowsAutomaticWindowTabbing = false }
                .onAppear(perform: Spyglass.setup)
                .onAppear(perform: Spyglass.run)
        }
        .commands {
            CommandMenu("IP Address") {
                Toggle(
                    "Local",
                    isOn: Binding(
                        get: { viewStore.isLocalHost },
                        set: { _,_ in viewStore.updateIp(.local) }
                    )
                )
                Toggle(
                    viewStore.ipAddress,
                    isOn: Binding(
                        get: { !viewStore.isLocalHost },
                        set: { _,_ in viewStore.updateIp(.custom) }
                    )
                )
            }
        }
    }
}
