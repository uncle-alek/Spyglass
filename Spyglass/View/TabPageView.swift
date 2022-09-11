//
//  File.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import SwiftUI

struct TabPageView: View {
    
    @State var page: LensView.TabView.Tab.ContentPage
    
    var body: some View {
        Group {
            switch page.type {
            case .string(let text, let showRewriteButton):
                TextEditorView(
                    text: text,
                    showRewriteButton: showRewriteButton
                )
            case .tree(let tree):
                TreeView(tree: [tree])
            }
        }
    }
}
