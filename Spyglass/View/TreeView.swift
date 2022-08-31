//
//  TreeView.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import SwiftUI

struct TreeView: View {
    
    let tree: LensView.TabView.TreeNode

    var body: some View {
        List {
            OutlineGroup(tree, children: \.children) { child in
                if let value = child.value {
                    HStack {
                        Image(systemName: "doc")
                        Text("\(child.name) :")
                        Text("\(value)")
                            .bold()
                    }.textSelection(.enabled)
                } else {
                    HStack {
                        Image(systemName: "folder")
                        Text(child.name)
                    }
                }
            }
        }
    }
}
