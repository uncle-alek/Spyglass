//
//  TextEd.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import CodeEditor
import Dispatch
import SwiftUI

fileprivate enum Constant {
    static let zeroRange = "".startIndex..<"".startIndex
}

struct TextEditorView: View {
    
    @EnvironmentObject var viewStore: ViewStore
    
    @State var currentIndex: Int?
    @State var ranges: CircularBuffer<Range<String.Index>> = []
    @StateObject var textDebouncer = TextDebouncer(delay: .milliseconds(500))
    @State private var selection: Range<String.Index> = Constant.zeroRange
    
    @State var text: String
    let showRewriteButton: Bool
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    SearchField(
                        searchText: $textDebouncer.searchText
                    )
                    .padding([.leading, .trailing])
                    
                    Button {
                        currentIndex = currentIndex.map(ranges.index(after:)) ?? ranges.startIndex
                    } label: {
                        Text("Find Next")
                    }
                    .disabled(ranges.isEmpty)
                    .keyboardShortcut("g", modifiers: [.command])
                    
                    Button {
                        currentIndex = currentIndex.map(ranges.index(before:)) ?? ranges.endIndex - 1
                    } label: {
                        Text("Find Previous")
                    }
                    .disabled(ranges.isEmpty)
                    .keyboardShortcut("g", modifiers: [.shift, .command])
                    .padding(.trailing)
                    
                    if showRewriteButton {
                        Button {
                            viewStore.rewrite(text)
                        } label: {
                            Image(systemName: "square.and.pencil")
                        }
                        .padding(.trailing)
                    }
                }
                HStack {
                    Text(
                        ranges.isEmpty
                        ? "no matches"
                        : currentIndex != nil
                        ? "\(currentIndex! + 1) of \(ranges.count) matches"
                        : "\(ranges.count) matches"
                    )
                    Spacer()
                }
                .padding([.leading, .trailing])
                .padding([.top], 10)
            }
            .padding([.leading, .trailing, .top])
            
            CodeEditor(
                source: $text,
                selection: $selection,
                language: .json,
                theme: .pojoaque
            )
            .onChange(of: textDebouncer.debouncedText) { search in
                DispatchQueue.global(qos: .background).async {
                    ranges = .init(text.ranges(of: search))
                    currentIndex = nil
                    selection = Constant.zeroRange
                }
            }
            .onChange(of: currentIndex) { currentIndex in
                guard let currentIndex = currentIndex else { return }
                selection = ranges[currentIndex]
            }
        }
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

extension String {
            
    func ranges(of string: String) -> [Range<String.Index>] {
        guard !string.isEmpty else { return [] }
        return try! NSRegularExpression(pattern: string, options: [.caseInsensitive])
            .matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
            .map { $0.range }
            .map { Range($0, in: self)! }
    }
}
