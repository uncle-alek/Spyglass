//
//  CatalogView.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 1/9/22.
//

import SwiftUI

struct CatalogView: View {
    
    @EnvironmentObject var viewStore: ViewStore
    @Binding var selected: UUID?
    
    var body: some View {
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
        }
        .animation(.easeInOut, value: viewStore.tableView.rows.count)
    }
}
