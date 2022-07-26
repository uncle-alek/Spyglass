//
//  View.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Foundation

enum LensView {

    struct TableView {
        
        struct Row: Identifiable {
            let info1: String
            let info2: String
            let info3: String
            let info4: String
            let info5: String
            let id: UUID
        }
        
        struct Column {
            let name: String
        }
        
        let column1: Column
        let column2: Column
        let column3: Column
        let column4: Column
        let column5: Column
        let rows: [Row]
        
        static let `default` = TableView(
            column1: .init(name: ""),
            column2: .init(name: ""),
            column3: .init(name: ""),
            column4: .init(name: ""),
            column5: .init(name: ""),
            rows: []
        )
    }

    struct TabView {
        
        enum Value {
            case primitive(String)
            case array([String])
        }
        
        struct Content: Identifiable {
            let id = UUID()
            let name: String
            let value: Value?
            let childrens: [Content]?
            
            static let `default` = Content(
                name: "",
                value: nil,
                childrens: nil
            )
        }
        
        struct Tab {
            let name: String
            let content: [Content]
        }
        let tab1: Tab
        let tab2: Tab
        let tab3: Tab
        
        static let `default` = TabView(
            tab1: .init(name: "", content: []),
            tab2: .init(name: "", content: []),
            tab3: .init(name: "", content: [])
        )
    }
}
