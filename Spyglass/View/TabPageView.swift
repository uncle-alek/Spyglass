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
