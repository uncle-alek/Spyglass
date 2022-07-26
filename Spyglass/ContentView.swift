//
//  ContentView.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewStore = Spyglass.viewStore
        
    var body: some View {
        HStack {
            Table(
                viewStore.tableView.rows,
                selection: Binding(
                    get: { nil },
                    set: { viewStore.select($0) }
                )
            ) {
                TableColumn(viewStore.tableView.column1.name, value: \.info1)
                TableColumn(viewStore.tableView.column2.name, value: \.info2)
                TableColumn(viewStore.tableView.column3.name, value: \.info3)
            }
            
            TabView {
                JSONView(items: viewStore.tabView.tab1.content)
                    .tabItem { Text(viewStore.tabView.tab1.name) }

                JSONView(items: viewStore.tabView.tab2.content)
                    .tabItem { Text(viewStore.tabView.tab2.name) }

                JSONView(items: viewStore.tabView.tab3.content)
                    .tabItem { Text(viewStore.tabView.tab3.name) }
            }
        }
    }
}

struct JSONView: View {
    
    let items: [LensView.TabView.Content]

    var body: some View {
        NavigationView{
            List{
                ForEach(items) { item in
                    DisclosureGroup(item.name) {
                        OutlineGroup(item, children:\.childrens) { child in
                            if let value = child.value {
                                switch value {
                                case .primitive(let data):
                                    NavigationLink(
                                        destination: PrimitiveView(text: data)
                                    ) {
                                        Text(child.name)
                                    }
                                case .array(let array):
                                    NavigationLink(
                                        destination: ArrayView(text: array)
                                    ) {
                                        Text(child.name)
                                    }
                                }
                            } else {
                                Text(child.name)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct PrimitiveView: View {
    
    @State var text: String
    
    var body: some View {
        TextEditor(text: $text)
    }
}

struct ArrayView: View {
    
    @State var text: [String]
    
    var body: some View {
        PrimitiveView(text: text.reduce("", { $0 + "\n" + $1}))
    }
}
