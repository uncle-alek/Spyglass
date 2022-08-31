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
    @Binding var ranges: [NSRange]
    let currentIndex: Int
    
    var body: some View {
        switch page.type {
        case .string(let text):
            TextEd(
                text: text,
                searchText: searchText,
                ranges: $ranges,
                currentIndex: currentIndex)
        case .tree(let tree):
            TreeView(tree: [tree])
        }
    }
}
