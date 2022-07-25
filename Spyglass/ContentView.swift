//
//  ContentView.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import SwiftUI

struct ContentView: View {
    
    let table: TableView4 = tv4
    
    var body: some View {
        Table(table.rows) {
            TableColumn(table.column1.name, value: \.info1)
            TableColumn(table.column2.name, value: \.info2)
            TableColumn(table.column3.name, value: \.info3)
            TableColumn(table.column4.name, value: \.info4)
        }
    }
}
