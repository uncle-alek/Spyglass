import AppKit
import OutlineView
import SwiftUI

struct TreeView: View {
    
    @State var tree: [LensView.TabView.TreeNode]
    @State var selection: LensView.TabView.TreeNode?

    var body: some View {
        OutlineView(
            tree,
            children: \.children,
            selection: $selection
        ) { child in
            if let value = child.value {
                return NSStackView(views: [
                    NSImageView(image: NSImage(systemSymbolName: "doc.plaintext", accessibilityDescription: nil)!.setup(.systemGray)),
                    NSTextField(string: "\(child.name) : \(value)").setup(),
                ]).setup()
            } else {
                return NSStackView(views: [
                    NSImageView(image: NSImage(systemSymbolName: child.toFolderImage, accessibilityDescription: nil)!.setup(.systemYellow)),
                    NSTextField(string: child.name).setup()
                ]).setup()
            }
        }
        .outlineViewIndentation(20)
    }
}

extension LensView.TabView.TreeNode {
    
    var toFolderImage: String {
        children == nil || children?.isEmpty == true
        ? "folder"
        : "folder.fill"
    }
}

extension NSImage {
    
    func setup(_ color: NSColor) -> NSImage {
        let config = NSImage.SymbolConfiguration(hierarchicalColor: color)
        return self.withSymbolConfiguration(config)!
    }
}

extension NSTextField {
    
    func setup() -> NSTextField {
        self.isBordered = false
        self.isEditable = false
        self.backgroundColor = .clear
        return self
    }
}

extension NSStackView {
    
    func setup() -> NSStackView {
        self.orientation = .horizontal
        self.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return self
    }
}
