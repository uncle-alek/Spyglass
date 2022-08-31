//
//  ViewState.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import CustomDump
import Foundation

struct AppViewState: Equatable {
    var tableView: LensView.TableView
    var tabView: LensView.TabView
    var sharingHistory: String?
    
    init(_ state: AppState) {
        self.tableView = LensView.TableView(
            column1: .init(name: "Action"),
            column2: .init(name: "Timestamp"),
            rows: state.events.rows
        )
        self.tabView = LensView.TabView(
            tabs: [
                .init(
                    name: "States Diff",
                    pages: [
                        state.selectedItem.map { .init(name: "", type: .string($0.diff)) }
                    ].compactMap { $0 }
                ),
                .init(
                    name: "State Before",
                    pages: [
                        state.selectedItem.map { .init(name: "JSON", type: .tree(LensView.TabView.TreeNode("AppState", $0.stateBefore))) },
                        state.selectedItem.map { .init(name: "Raw", type: .string($0.stateBefore.prettyPrinted)) }
                    ].compactMap { $0 }
                ),
                .init(
                    name: "State After",
                    pages: [
                        state.selectedItem.map { .init(name: "JSON", type: .tree(LensView.TabView.TreeNode("AppState", $0.stateAfter))) },
                        state.selectedItem.map { .init(name: "Raw", type: .string($0.stateAfter.prettyPrinted)) }
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
            format: .init(first: "\u{274C}", second: "\u{2705}", both: " ")
        ) ?? "no changes..."
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
