//
//  View.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Foundation

struct TableView4 {
    
    struct Row: Identifiable {
        let info1: String
        let info2: String
        let info3: String
        let info4: String
        let id = UUID()
    }
    
    struct Column {
        let name: String
    }
    
    let column1: Column
    let column2: Column
    let column3: Column
    let column4: Column
    let rows: [Row]
    
    static let `default` = TableView4(
        column1: .init(name: ""),
        column2: .init(name: ""),
        column3: .init(name: ""),
        column4: .init(name: ""),
        rows: []
    )
}
