//
//  File.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import SwiftUI

struct TabPageView: View {
    
    let page: LensView.TabView.Tab.ContentPage
    let searchText: String
    
    var body: some View {
        switch page.type {
        case .string(let text):
            TextEditorView(
                text: text,
                searchText: searchText
            )
        case .tree(let tree):
            TreeView(tree: [tree])
        }
    }
}
