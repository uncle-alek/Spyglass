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
    
    private var values: [(UUID, TAGAAction)] = []
    private let tableSubject = PassthroughSubject<LensView.TableView, Never>()
    private let tabSubject = PassthroughSubject<LensView.TabView, Never>()

    func setup() {
        let table = LensView.TableView(
            column1: .init(name: "Action"),
            column2: .init(name: "Timestamp"),
            column3: .init(name: "Payload"),
            rows: []
        )
        tableSubject.send(table)
        let tab = LensView.TabView(
            tabs: [
                .init(name: "State Before", content: .string("")),
                .init(name: "State After", content: .string("")),
                .init(name: "Diff", content: .string(""))
            ]
        )
        tabSubject.send(tab)
    }
    
    func receive(_ value: String) {
        let action = parse(value)
        values.append((UUID(), action))
        let table = LensView.TableView(
            column1: .init(name: "Action"),
            column2: .init(name: "Timestamp"),
            column3: .init(name: "Payload"),
            rows: values.map {
                .init(
                    info1: $0.1.name,
                    info2: $0.1.timestamp.toString(),
                    info3: $0.1.payload,
                    id: $0.0
                )
            }
        )
        tableSubject.send(table)
    }
    
    func selectItem(with id: UUID) {
        guard let value = values.first(where: { $0.0 == id }) else { return }
        let tab = LensView.TabView(
            tabs: [
                .init(name: "State Before", content: .tree(map(value.1.stateBefore))),
                .init(name: "State After", content: .tree(map(value.1.stateAfter))),
                .init(name: "Diff", content: .string(diff(value.1.stateBefore, value.1.stateAfter)!))
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
        for (key, value) in dict {
            var childrens: [LensView.TabView.TreeNode]? = nil
            var contentValue: LensView.TabView.Value? = nil
            if let value = value as? [String: Any] {
                childrens = map(value)
            } else if let value = value as? [Any] {
                contentValue = .array(value.compactMap(map(primitive:)))
            } else {
                contentValue = .primitive(map(primitive:value))
            }
            contents.append(
                LensView.TabView.TreeNode(
                    name: key,
                    value: contentValue,
                    childrens: childrens
                )
            )
        }
        return contents
    }
    
    func map(primitive: Any) -> String {
        if let value = primitive as? Int {
           return String(value)
        } else if let value = primitive as? String {
           return String(value)
        } else if let value = primitive as? Bool {
           return String(value)
        }
        fatalError()
    }
}

extension TimeInterval {
    
    func toString() -> String {
        String(self)
    }
}
