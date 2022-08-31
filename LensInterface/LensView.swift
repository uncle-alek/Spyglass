//
//  View.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Foundation

enum LensView {

    struct TableView: Equatable {
        
        struct Row: Identifiable, Equatable {
            let info1: String
            let info2: String
            let id: UUID
        }
        
        struct Column: Equatable {
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

    struct TabView: Equatable {
        
        struct TreeNode: Identifiable, Hashable {
            let id = UUID()
            let name: String
            let value: String?
            let children: [TreeNode]?
            
            static let `default` = TreeNode(
                name: "",
                value: nil,
                children: nil
            )
        }
        
        struct Tab: Identifiable, Hashable {
            enum ContentType: Hashable {
                case string(String)
                case tree(TreeNode)
            }
            struct ContentPage: Identifiable, Hashable {
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

extension LensView.TabView.TreeNode {
    
    public init(_ rootName: String, _ dict: [String: Any]) {
        self.init(
            name: rootName,
            value: nil,
            children: LensView.TabView.TreeNode.map(dict)
        )
    }
    
    static public func map(_ dict: [String: Any]) -> [LensView.TabView.TreeNode] {
        var contents: [LensView.TabView.TreeNode] = []
        
        for (key, value) in dict.sorted(
            by: { $0.0.localizedStandardCompare($1.0) == .orderedAscending }
        ) {
            var children: [LensView.TabView.TreeNode]? = nil
            var contentValue: String? = nil
            if let value = value as? [String: Any] {
                if value.isEmpty {
                    children = nil
                } else {
                    children = map(value)
                }
            } else if let value = value as? [Any] {
                children = map(
                    zip(1..., value).reduce(into: [String: Any]()) { (dict, zippedPair) in
                        let (index, value) = zippedPair
                        dict[String(index)] = value
                    }
                )
            } else {
                contentValue = String(reflecting: value)
            }
            contents.append(
                LensView.TabView.TreeNode(
                    name: key,
                    value: contentValue,
                    children: children?.isEmpty == true ? nil : children
                )
            )
        }
        return contents
    }
}
