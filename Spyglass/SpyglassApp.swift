//
//  SpyglassApp.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import SwiftUI

@main
struct SpyglassApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear { NSWindow.allowsAutomaticWindowTabbing = false }
                .onAppear(perform: Spyglass.run)
        }
    }
}
