//
//  TextEd.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import SwiftUI
import HighlightedTextEditor

struct TextEd: View {
    
    @State var text: String
    let searchText: String
    @Binding var ranges: [NSRange]
    let currentIndex: Int
    
    var body: some View {
        VStack {
            HighlightedTextEditor(
                text: $text,
                highlightRules: highlightRules
            ).introspect { editor in
                guard currentIndex < ranges.count else { return }
                editor.textView.scrollRangeToVisible(ranges[currentIndex])
                editor.textView.setTextColor(NSColor.yellow, range: ranges[currentIndex])
            }
            .onChange(of: searchText) {
                ranges = text.ranges(of: $0)
            }
            .onAppear {
                ranges = text.ranges(of: searchText)
            }
        }
    }
}

private extension TextEd {
    
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
