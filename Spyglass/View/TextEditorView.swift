//
//  TextEd.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import SwiftUI
import HighlightedTextEditor

struct TextEditorView: View {
    
    @State var text: String
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            SearchField(searchText: $searchText)
            HighlightedTextEditor(
                text: $text,
                highlightRules: highlightRules
            )
        }
    }
}

private extension TextEditorView {
    
    var highlightRules: [HighlightRule] {
        guard let regEx = try? NSRegularExpression(pattern: searchText, options: [])
            else { return [] }
        return [
            HighlightRule(
                pattern: regEx,
                formattingRules: [
                    TextFormattingRule(key: .backgroundColor, value: NSColor.red.withAlphaComponent(0.3))
                ]
            )
        ]
    }
}
