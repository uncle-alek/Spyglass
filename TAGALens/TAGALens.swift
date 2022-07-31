//
//  TAGALens.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Combine
import CustomDump
import Foundation

final class TAGALens: Lens {
    
    var tablePublisher: AnyPublisher<LensView.TableView, Never> { tableSubject.eraseToAnyPublisher() }
    var tabPublisher: AnyPublisher<LensView.TabView, Never> { tabSubject.eraseToAnyPublisher() }
    var connectionPath: String { "taga" }
    
    private var actions: [(UUID, TAGAAction)] = []
    private let tableSubject = PassthroughSubject<LensView.TableView, Never>()
    private let tabSubject = PassthroughSubject<LensView.TabView, Never>()

    func setup() {
        let table = LensView.TableView(
            column1: .init(name: "Action"),
            column2: .init(name: "Timestamp"),
            rows: []
        )
        tableSubject.send(table)
        let tab = LensView.TabView(
            tabs: [
                .init(name: "Diff", pages: []),
                .init(name: "State Before", pages: []),
                .init(name: "State After", pages: [])
            ]
        )
        tabSubject.send(tab)
    }
    
    func receive(_ value: String) {
        let action = parse(value)
        actions.append((UUID(), action))
        let table = LensView.TableView(
            column1: .init(name: "Action"),
            column2: .init(name: "Timestamp"),
            rows: map(actions: actions).reversed()
        )
        tableSubject.send(table)
    }
    
    func selectItem(with id: UUID) {
        guard let action = actions.first(where: { $0.0 == id }) else { return }
        let tab = LensView.TabView(
            tabs: [
                .init(name: "Diff", pages: [
                    .init(name: "", type: .string(diff(for: action.1)))
                ]),
                .init(name: "State Before", pages: [
                    .init(name: "JSON", type: .tree(map(action.1.stateBefore))),
                    .init(name: "Raw", type: .string(customDump(action.1.formattedStateBefore)))
                ]),
                .init(name: "State After", pages: [
                    .init(name: "JSON", type: .tree(map(action.1.stateAfter))),
                    .init(name: "Raw", type: .string(customDump(action.1.formattedStateAfter)))
                ])
            ]
        )
        tabSubject.send(tab)
    }
}

extension TAGALens {
    
    func parse(_ value: String) -> TAGAAction {
        let data = value.data(using: .utf8)!
        return try! JSONDecoder().decode(TAGAAction.self, from: data)
    }
    
    func map(_ dict: [String: Any]) -> [LensView.TabView.TreeNode] {
        var contents: [LensView.TabView.TreeNode] = []
        
        for (key, value) in dict.sorted(
            by: { $0.0.localizedStandardCompare($1.0) == .orderedAscending }
        ) {
            var childrens: [LensView.TabView.TreeNode]? = nil
            var contentValue: String? = nil
            if let value = value as? [String: Any] {
                if value.isEmpty {
                    childrens = nil
                } else {
                    childrens = map(value)
                }
            } else if let value = value as? [Any] {
                childrens = map(
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
                    childrens: childrens?.isEmpty == true ? nil : childrens
                )
            )
        }
        return contents
    }

    func map(actions: [(UUID, TAGAAction)]) -> [LensView.TableView.Row] {
        var rows: [LensView.TableView.Row] = []
        for (index, action) in actions.enumerated() {
            let timeStamp: TimeInterval
            if index == 0 {
                timeStamp = 0
            } else {
                let previousAction = actions[index - 1]
                timeStamp = action.1.timestamp - previousAction.1.timestamp
            }
            let row = LensView.TableView.Row.init(
                info1: action.1.name,
                info2: timeStamp.toString(),
                id: action.0
            )
            rows.append(row)
        }
        return rows
    }
    
    func diff(for action: TAGAAction) -> String {
        CustomDump.diff(
            action.stateBefore,
            action.stateAfter,
            format: .init(first: "\u{274C}", second: "\u{2705}", both: " ")
        )!
    }
}

extension TimeInterval {
    
    func toString() -> String {
        String(format: "+ %0.1d:%0.3d", seconds, milliseconds)
    }
    
    var seconds: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    
    var milliseconds: Int {
        Int((self*1000).truncatingRemainder(dividingBy: 1000))
    }
}
