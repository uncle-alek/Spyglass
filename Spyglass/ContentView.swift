//
//  ContentView.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import SwiftUI
import HighlightedTextEditor

struct ContentView: View {
    
    @ObservedObject var viewStore = Spyglass.viewStore
    @State var selected: UUID?
    @State var searchText: String = ""
    @State private var selectedExternalTab = 0
    @State private var selectedInternalTab = 0
    @State var ranges: [NSRange] = []
    @State var currentIndex: Int = 0
        
    var body: some View {
        HStack {
            Table(
                viewStore.tableView.rows,
                selection: Binding(
                    get: { selected },
                    set: {
                        self.selected = $0
                        guard let selected = selected else { return }
                        viewStore.select(selected)
                    }
                )
            ) {
                TableColumn(viewStore.tableView.column1.name, value: \.info1)
                TableColumn(viewStore.tableView.column2.name, value: \.info2)
            }.animation(.easeInOut, value: viewStore.tableView.rows.count)
            
            TabView(selection: $selectedExternalTab) {
                ForEach(Array(viewStore.tabView.tabs.enumerated()), id: \.1) { index, tab in
                    Group {
                        if tab.pages.count == 1 {
                            TabPageView(
                                page: tab.pages.first!,
                                searchText: searchText,
                                ranges: $ranges,
                                currentIndex: currentIndex
                            )
                        } else {
                            TabView(selection: $selectedInternalTab) {
                                ForEach(Array(tab.pages.enumerated()), id: \.1) { index, page in
                                    TabPageView(
                                        page: page,
                                        searchText: searchText,
                                        ranges: $ranges,
                                        currentIndex: currentIndex
                                    )
                                    .tabItem { Text(page.name) }
                                    .tag(index)
                                }
                            }
                        }
                    }
                    .tabItem { Text(tab.name) }
                    .tag(index)
                }
            }
            .onChange(of: ranges) { _ in
                currentIndex = 0
            }
            .searchable(text: $searchText)
        }
        .toolbar {
            Button {
                viewStore.reset()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            Button {
                guard let selected = selected else { return }
                viewStore.navigateTo(selected)
            } label: {
                Image(systemName: "scope")
            }
            .disabled(selected == nil)
            
            Spacer()
            
            Button {
                currentIndex = (currentIndex + 1) % ranges.count
            } label: {
                Text("Find")
            }
            .disabled(searchText.isEmpty)
            Button {
                currentIndex = (currentIndex - 1) % ranges.count
                currentIndex = currentIndex < 0 ? ranges.count + currentIndex : currentIndex
            } label: {
                Text("Find Prev")
            }
            .disabled(searchText.isEmpty)
        }
    }
}

struct TabPageView: View {
    
    let page: LensView.TabView.Tab.ContentPage
    let searchText: String
    @Binding var ranges: [NSRange]
    let currentIndex: Int
    
    var body: some View {
        switch page.type {
        case .string(let text):
            TextEd(
                text: text,
                searchText: searchText,
                ranges: $ranges,
                currentIndex: currentIndex)
        case .tree(let tree):
            JSONView(items: tree)
        }
    }
}

struct JSONView: View {
    
    let items: [LensView.TabView.TreeNode]

    var body: some View {
        List{
            ForEach(items) { item in
                OutlineGroup(item, children:\.childrens) { child in
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
}

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
