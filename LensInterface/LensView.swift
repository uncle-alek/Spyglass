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
            let id: UUID
        }
        
        struct Column {
            let name: String
        }
        
        let column1: Column
        let column2: Column
        let column3: Column
        let rows: [Row]
        
        static let `default` = TableView(
            column1: .init(name: ""),
            column2: .init(name: ""),
            column3: .init(name: ""),
            rows: []
        )
    }

    struct TabView {
        
        enum Value {
            case primitive(String)
            case array([String])
        }
        
        struct TreeNode: Identifiable {
            let id = UUID()
            let name: String
            let value: Value?
            let childrens: [TreeNode]?
            
            static let `default` = TreeNode(
                name: "",
                value: nil,
                childrens: nil
            )
        }
        
        enum Content {
            case string(String)
            case tree([TreeNode])
        }
        
        struct Tab: Identifiable {
            let id = UUID()
            let name: String
            let content: Content
        }
        
        let tabs: [Tab]
        
        static let `default` = TabView(
            tabs: []
        )
    }
}
