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
            TableColumn(viewStore.tableView.column1.name) {
                Text($0.info1)
                    .textSelection(.enabled)
            }
            TableColumn(viewStore.tableView.column2.name) {
                Text($0.info2)
                    .textSelection(.enabled)
            }
            TableColumn(viewStore.tableView.column3.name) {
                Text($0.info3)
                    .textSelection(.enabled)
            }
        }
        .animation(.easeInOut, value: viewStore.tableView.rows.count)
    }
}
