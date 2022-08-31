//
//  ViewState.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import CustomDump
import Foundation

fileprivate enum Strings {
    enum Column {
        static let action = "Action"
        static let timestamp = "Timestamp"
    }
    enum Tab {
        static let diff = "States Diff"
        static let before = "State Before"
        static let after = "State After"
        static let json = "JSON"
        static let raw = "Raw"
    }
    enum Tree {
        static let head = "AppState"
    }
    enum Diff {
        static let noChanges = "no changes..."
        static let removed = "\u{274C}"
        static let added = "\u{2705}"
    }
}

struct AppViewState: Equatable {
    var tableView: LensView.TableView
    var tabView: LensView.TabView
    var sharingHistory: String?
    
    init(_ state: AppState) {
        self.tableView = LensView.TableView(
            column1: .init(name: Strings.Column.action),
            column2: .init(name: Strings.Column.timestamp),
            rows: state.events.rows
        )
        self.tabView = LensView.TabView(
            tabs: [
                .init(
                    name: Strings.Tab.diff,
                    pages: [
                        state.selectedItem.map {
                            .init(name: "", type: .string($0.diff))
                        }
                    ].compactMap { $0 }
                ),
                .init(
                    name: Strings.Tab.before,
                    pages: [
                        state.selectedItem.map {
                            .init(name: Strings.Tab.json, type: .tree(LensView.TabView.TreeNode(Strings.Tree.head, $0.stateBefore)))
                        },
                        state.selectedItem.map {
                            .init(name: Strings.Tab.raw, type: .string($0.stateBefore.prettyPrinted))
                        }
                    ].compactMap { $0 }
                ),
                .init(
                    name: Strings.Tab.after,
                    pages: [
                        state.selectedItem.map {
                            .init(name: Strings.Tab.json, type: .tree(LensView.TabView.TreeNode(Strings.Tree.head, $0.stateAfter)))
                        },
                        state.selectedItem.map {
                            .init(name: Strings.Tab.raw, type: .string($0.stateAfter.prettyPrinted))
                        }
                    ].compactMap { $0 }
                )
            ]
        )
        self.sharingHistory = state.events.isEmpty ? nil : state.events.sharingData
    }
}

extension ReduxEvent {
    
    var diff: String {
        CustomDump.diff(
            self.stateBefore,
            self.stateAfter,
            format: .init(first: Strings.Diff.removed, second: Strings.Diff.added, both: " ")
        ) ?? Strings.Diff.noChanges
    }
}

extension Array where Element == (UUID, ReduxEvent) {
    
    var rows: [LensView.TableView.Row] {
        zip(self.timestampDiff, self)
        .map { t, e in .init(info1: e.1.name, info2: t.toString(), id: e.0)}
        .reversed()
    }
    
    var sharingData: String {
        zip(self, self.timestampDiff)
        .map { e, t in e.1.name + ", " + t.toString() }
        .reversed()
        .joined(separator: "\n")
    }
    
    var timestampDiff: [TimeInterval] {
        [0] + zip(self.dropFirst(), self.dropLast()).map { $0.1.timestamp - $1.1.timestamp }
    }
}

extension Dictionary where Key == String, Value: Any {
    
    var prettyPrinted: String {
        let data = try! JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .sortedKeys])
        return String(decoding: data, as: UTF8.self)
    }
}

extension TimeInterval {
    
    func toString() -> String {
        String(format: "+ %0.1d:%0.3d s", seconds, milliseconds)
    }
    
    var seconds: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    
    var milliseconds: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
