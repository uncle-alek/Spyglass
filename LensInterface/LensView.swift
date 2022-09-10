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
            let id: String
            let name: String
            let value: String?
            let children: [TreeNode]?
            
            static let `default` = TreeNode(
                id: "",
                name: "",
                value: nil,
                children: nil
            )
        }
        
        struct Tab: Identifiable, Hashable {
            enum ContentType: Hashable {
                case string(text: String, showRewriteButton: Bool)
                case tree(TreeNode)
            }
            struct ContentPage: Identifiable, Hashable {
                let id: String
                let name: String
                let type: ContentType
            }
            
            let id: String
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
            id: rootName,
            name: rootName,
            value: nil,
            children: dict.treeNodes
        )
    }
}

extension Dictionary where Key == String, Value: Any {
    
    var treeNodes: [LensView.TabView.TreeNode] {
        var contents: [LensView.TabView.TreeNode] = []
        
        for (key, value) in self.sorted(
            by: { $0.0.localizedStandardCompare($1.0) == .orderedAscending }
        ) {
            var children: [LensView.TabView.TreeNode]? = nil
            var contentValue: String? = nil
            if let value = value as? [String: Any] {
                children = value.treeNodes
            } else if let value = value as? [Any] {
                children = value.numberedDictionary.treeNodes
            } else {
                contentValue = String(reflecting: value)
            }
            contents.append(
                LensView.TabView.TreeNode(
                    id: key,
                    name: key,
                    value: contentValue,
                    children: children?.isEmpty == true ? nil : children
                )
            )
        }
        return contents
    }
}

extension Array {
    
    var numberedDictionary: [String: Element] {
        zip(1..., self).reduce(into: [String: Element]()) { (result, zippedPair) in
            let (index, value) = zippedPair
            result[String(index)] = value
        }
    }
}
