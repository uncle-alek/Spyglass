//
//  ContentView.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewStore = Spyglass.viewStore
    @State var selected: UUID?
        
    var body: some View {
        HStack {
            Table(
                viewStore.tableView.rows,
                selection: Binding(
                    get: { selected },
                    set: {
                        self.selected = $0
                        viewStore.select($0)
                    }
                )
            ) {
                TableColumn(viewStore.tableView.column1.name, value: \.info1)
                TableColumn(viewStore.tableView.column2.name, value: \.info2)
            }.animation(.easeInOut, value: viewStore.tableView.rows.count)
            
            TabView {
                ForEach(viewStore.tabView.tabs) { tab in
                    Group {
                        switch tab.content {
                        case .string(let text):
                            TextView(text: text)
                        case .tree(let tree):
                            JSONView(items: tree)
                        }
                    }
                    .tabItem { Text(tab.name) }
                }
            }
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

struct TextView: View {
    
    @State var text: String
    
    var body: some View {
        TextEditor(text: $text)
    }
}
