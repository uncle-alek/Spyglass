//
//  TreeView.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import AppKit
import OutlineView
import SwiftUI

struct TreeView: View {
    
    let tree: [LensView.TabView.TreeNode]
    @State var selection: LensView.TabView.TreeNode?

    var body: some View {
        OutlineView(
            tree,
            children: \.children,
            selection: $selection
        ) { child in
            if let value = child.value {
                return NSStackView(views: [
                    NSImageView(image: NSImage(systemSymbolName: "doc", accessibilityDescription: nil)!),
                    NSTextField(string: "\(child.name) : \(value)").setup(),
                ]).setup()
            } else {
                return NSStackView(views: [
                    NSImageView(image: NSImage(systemSymbolName: "folder", accessibilityDescription: nil)!),
                    NSTextField(string: child.name).setup()
                ]).setup()
            }
        }
        .outlineViewIndentation(20)
    }
}

extension NSTextField {
    
    func setup() -> Self {
        self.isBordered = false
        self.isEditable = false
        return self
    }
}

extension NSStackView {
    
    func setup() -> Self {
        self.orientation = .horizontal
        self.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return self
    }
}
