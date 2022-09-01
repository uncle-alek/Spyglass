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
    let searchText: String
    
    var body: some View {
        VStack {
            HighlightedTextEditor(
                text: $text,
                highlightRules: highlightRules
            )
        }
    }
}

private extension TextEditorView {
    
    var highlightRules: [HighlightRule] {
        guard let regEx = try? NSRegularExpression(pattern: "\(searchText)", options: [])
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

extension String {
    
    func ranges(of searchString: String) -> [NSRange] {
        var ranges: [Range<String.Index>] = []
        var currentString: Substring = self[startIndex...]
        var currentRange = currentString.range(of: searchString)
        while(currentRange != nil) {
            ranges.append(currentRange!)
            currentString = currentString[currentRange!.upperBound...]
            currentRange = currentString.range(of: searchString)
        }
        return ranges.map { NSRange($0, in: self) }
    }
}
