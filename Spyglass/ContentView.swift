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
                            TabPageView(page: tab.pages.first!, searchText: searchText)
                        } else {
                            TabView(selection: $selectedInternalTab) {
                                ForEach(Array(tab.pages.enumerated()), id: \.1) { index, page in
                                    TabPageView(page: page, searchText: searchText)
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
        }
    }
}

struct TabPageView: View {
    
    let page: LensView.TabView.Tab.ContentPage
    let searchText: String
    
    var body: some View {
        switch page.type {
        case .string(let text):
            TextEd(text: text, searchText: searchText)
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
//    @Binding var goToNext: Bool
//    @State private var ranges: [Range<String.Index>] = []
//    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            HighlightedTextEditor(
                text: $text,
                highlightRules: highlightRule(for: searchText)
            ).introspect { editor in
                if let range = text.range(of: searchText) {
                    editor.textView.scrollRangeToVisible(NSRange(range, in: text))
                }
            }
        }
    }
    
    func highlightRule(for searchText: String) -> [HighlightRule] {
        if let regEx = try? NSRegularExpression(pattern: "\(searchText)", options: []) {
            return [
                HighlightRule(
                    pattern: regEx,
                    formattingRules: [
                        TextFormattingRule(key: .backgroundColor, value: NSColor.red.withAlphaComponent(0.3))
                    ]
                )
            ]
        } else {
            return []
        }
    }
}
