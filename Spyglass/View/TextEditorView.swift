//
//  TextEd.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import SwiftUI
import HighlightedTextEditor

struct TextEditorView: View {
    
    struct Indices: Equatable {
        var current: Int = 0
        var previous: Int = 0
    }
    
    @State var text: String
    @State var indices: Indices = .init()
    @State var ranges: CircularBuffer<NSRange> = []
    @State var textView: NSTextView!
    @StateObject var textDebouncer = TextDebouncer(delay: .milliseconds(500))
    
    var body: some View {
        VStack {
            HStack {
                SearchField(searchText: $textDebouncer.searchText)
                Button {
                    indices.previous = indices.current
                    indices.current = ranges.index(after: indices.current)
                    
                    updateTextView()
                } label: {
                    Text("Find Next")
                }
                .disabled(ranges.isEmpty)
                Button {
                    indices.previous = indices.current
                    indices.current = ranges.index(before: indices.current)
                    
                    updateTextView()
                } label: {
                    Text("Find Previous")
                }
                .disabled(ranges.isEmpty)
                .padding(.trailing)
            }
            .onChange(of: textDebouncer.debouncedText) { search in
                ranges = .init(text.ranges(string: search))
                indices = .init()
                updateTextView()
            }
            HighlightedTextEditor(
                text: $text,
                highlightRules: highlightRules
            ).introspect { editor in
                textView = editor.textView
            }
        }
    }
}

private extension TextEditorView {
    
    func updateTextView() {
        guard !ranges.isEmpty else { return }
        textView.scrollRangeToVisible(ranges[indices.current])
        textView.textStorage?.addAttribute(.backgroundColor, value: NSColor.lightGray.withAlphaComponent(0.3), range: ranges[indices.current])
        textView.textStorage?.addAttribute(.backgroundColor, value: NSColor.systemGreen.withAlphaComponent(0.3), range: ranges[indices.previous])
    }
}

private extension TextEditorView {
    
    var highlightRules: [HighlightRule] {
        guard let regEx = try? NSRegularExpression(pattern: textDebouncer.debouncedText, options: [])
            else { return [] }
        return [
            HighlightRule(
                pattern: regEx,
                formattingRules: [
                    TextFormattingRule(key: .backgroundColor, value: NSColor.systemGreen.withAlphaComponent(0.3))
                ]
            )
        ]
    }
}

extension String {
    
    func ranges(string: String) -> [NSRange] {
        guard !string.isEmpty else { return [] }
        return try! NSRegularExpression(pattern: string, options: [])
            .matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            .map { $0.range }
    }
}

struct CircularBuffer<Element>: RandomAccessCollection, ExpressibleByArrayLiteral {
    
    private let array: [Element]
    
    init(_ array: [Element]) {
        self.array = array
    }
    
    init(arrayLiteral elements: Element...) {
        self.array = elements
    }
    
    var indices: Range<Int> {
        array.indices
    }
    
    var startIndex: Int {
        array.startIndex
    }
    
    var endIndex: Int {
        array.endIndex
    }
    
    func index(before i: Int) -> Int {
        (array.count + i - 1) % array.count
    }
    
    func index(after i: Int) -> Int {
        (i + 1) % array.count
    }
    
    subscript(index: Int) -> Element {
        array[index]
    }

    subscript(bounds: Range<Int>) -> ArraySlice<Element> {
        array[bounds]
    }
}

final class TextDebouncer : ObservableObject {

    @Published var debouncedText = ""
    @Published var searchText = ""

    init(delay: DispatchQueue.SchedulerTimeType.Stride) {
        $searchText
            .debounce(for: delay, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .assign(to: &$debouncedText)
    }
}
