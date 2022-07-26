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
                TableColumn(viewStore.tableView.column4.name, value: \.info4)
                TableColumn(viewStore.tableView.column5.name, value: \.info5)
            }
            
            TabView {
                Text(viewStore.tabView.tab1.content)
                    .tabItem { Text(viewStore.tabView.tab1.name) }

                Text(viewStore.tabView.tab2.content)
                    .tabItem { Text(viewStore.tabView.tab2.name) }

                Text(viewStore.tabView.tab3.content)
                    .tabItem { Text(viewStore.tabView.tab3.name) }
            }
        }
    }
}
