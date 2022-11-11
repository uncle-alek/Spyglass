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
        static let leadTime = "Lead Time"
        static let file = "File"
    }
    enum Tab {
        static let diff = "States Diff"
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
    var error: LensError?
    
    init(_ state: AppState) {
        self.tableView = LensView.TableView(
            column1: .init(name: Strings.Column.action),
            column2: .init(name: Strings.Column.leadTime),
            column3: .init(name: Strings.Column.file),
            rows: state.events.rows
        )
        self.tabView = LensView.TabView(
            tabs: [
                .init(
                    id: Strings.Tab.diff,
                    name: Strings.Tab.diff,
                    pages: [
                        state.selectedItem.map {
                            .init(
                                id: Strings.Tab.diff + Strings.Tab.raw,
                                name: "",
                                type: .string(text: $0.diff, showRewriteButton: false)
                            )
                        }
                    ].compactMap { $0 }
                ),
                .init(
                    id: Strings.Tab.after,
                    name: Strings.Tab.after,
                    pages: [
                        state.selectedItem.map {
                            .init(
                                id: Strings.Tab.after + Strings.Tab.json,
                                name: Strings.Tab.json,
                                type: .tree(LensView.TabView.TreeNode(Strings.Tree.head, $0.stateAfter))
                            )
                        },
                        state.selectedItem.map {
                            .init(
                                id: Strings.Tab.after + Strings.Tab.raw,
                                name: Strings.Tab.raw,
                                type: .string(text: $0.stateAfter.prettyPrinted, showRewriteButton: true)
                            )
                        }
                    ].compactMap { $0 }
                )
            ]
        )
        self.sharingHistory = state.events.isEmpty ? nil : state.events.sharingData
        self.error = state.error.map(LensError.init(reduxError:))
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
        map { .init(info1: $0.1.name, info2: $0.1.leadTime.toString(), info3: $0.1.file.toFileName, id: $0.0)}
        .reversed()
    }
    
    var sharingData: String {
        map { $0.1.name + ", " + $0.1.leadTime.toString() + ", " + $0.1.file.toFileName }
        .reversed()
        .joined(separator: "\n")
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
        String(format: "%0.1d:%0.3d s", seconds, milliseconds)
    }
    
    var seconds: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    
    var milliseconds: Int {
        Int((self * 1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension Optional where Wrapped == String {
    
    var toFileName: String {
        switch self {
        case .some(let value): return String(value.split(separator: "/").last!)
        case .none: return "no file information"
        }
    }
}

extension LensError {
    
    init(
        reduxError: ReduxError
    ) {
        self.errorDescription = reduxError.errorDescription
        self.failureReason = reduxError.failureReason
    }
}

extension ReduxError {
    
    var errorDescription: String {
        switch self {
        case .navigationFailedFileNotFound:
            return "Failed to navigate to IDE"
        case .navigationFailedLineNotFound:
            return "Failed to navigate to IDE"
        case .eventNotDeserialiazable:
            return "Failed to deserialize event"
        }
    }
    
    var failureReason: String {
        switch self {
        case .navigationFailedFileNotFound:
            return "File name not found"
        case .navigationFailedLineNotFound:
            return "File line not found"
        case .eventNotDeserialiazable(let decodingError):
            switch decodingError {
            case let .typeMismatch(type, _):
                return "Type '\(type)' mismatch"
            case let .valueNotFound(value, _):
                return "Value '\(value)' not found"
            case let .keyNotFound(key, _):
                return "Key '\(key)' not found"
            case .dataCorrupted(_):
                return "Corrupted date"
            @unknown default:
                return "Unknown reason"
            }
        }
    }
}
