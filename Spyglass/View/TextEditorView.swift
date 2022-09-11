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
    
    @State var currentIndex: Int = 0
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
                        currentIndex = ranges.index(after: currentIndex)
                    } label: {
                        Text("Find Next")
                    }
                    .disabled(ranges.isEmpty)
                    Button {
                        currentIndex = ranges.index(before: currentIndex)
                    } label: {
                        Text("Find Previous")
                    }
                    .disabled(ranges.isEmpty)
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
                        : "\(currentIndex) of \(ranges.count) matches"
                    )
                    Spacer()
                }
                .padding([.leading, .trailing])
                .padding([.top], 10)
            }
            CodeEditor(
                source: $text,
                selection: $selection,
                language: .json,
                theme: .pojoaque
            )
            .onChange(of: textDebouncer.debouncedText) { search in
                DispatchQueue.global(qos: .background).async {
                    ranges = .init(text.ranges(of: search))
                    currentIndex = 0
                    selection = Constant.zeroRange
                }
            }
            .padding([.leading, .trailing, .top, .bottom])
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
    
    func ranges(of occurrence: String) -> [Range<String.Index>] {
        var indices = [Range<String.Index>]()
        var position = startIndex
        while let range = range(of: occurrence, range: position..<endIndex) {
            indices.append(range)
            let offset = occurrence.distance(from: occurrence.startIndex, to: occurrence.endIndex) - 1
            if let after = index(range.lowerBound, offsetBy: offset, limitedBy: endIndex) {
                position = index(after: after)
            } else {
                break
            }
        }
        return indices
    }
}
