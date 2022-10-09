//
//  ContentView.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewStore = Spyglass.lensViewStore
    @State var selected: UUID?
        
    var body: some View {
        HSplitView {
            CatalogView(selected: $selected)
            TabCabinetView()
        }
        .toolbar {
            ToolKitView(selected: selected)
        }
        .environmentObject(viewStore)
    }
}
