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
        Table(viewStore.tableView.rows) {
            TableColumn(viewStore.tableView.column1.name, value: \.info1)
            TableColumn(viewStore.tableView.column2.name, value: \.info2)
            TableColumn(viewStore.tableView.column3.name, value: \.info3)
            TableColumn(viewStore.tableView.column4.name, value: \.info4)
        }
    }
}
