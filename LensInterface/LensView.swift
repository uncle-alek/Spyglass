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
            let id: UUID
        }
        
        struct Column {
            let name: String
        }
        
        let column1: Column
        let column2: Column
        let rows: [Row]
        
        static let `default` = TableView(
            column1: .init(name: ""),
            column2: .init(name: ""),
            rows: []
        )
    }

    struct TabView {
        
        struct TreeNode: Identifiable {
            let id = UUID()
            let name: String
            let value: String?
            let childrens: [TreeNode]?
            
            static let `default` = TreeNode(
                name: "",
                value: nil,
                childrens: nil
            )
        }
        
        struct Tab: Identifiable {
            enum ContentType {
                case string(String)
                case tree([TreeNode])
            }
            struct ContentPage: Identifiable {
                let id = UUID()
                let name: String
                let type: ContentType
            }
            
            let id = UUID()
            let name: String
            let pages: [ContentPage]
        }
        
        let tabs: [Tab]
        
        static let `default` = TabView(
            tabs: []
        )
    }
}
