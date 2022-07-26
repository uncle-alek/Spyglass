//
//  TAGALens.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Combine
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
            column4: .init(name: "State Before"),
            column5: .init(name: "State After"),
            rows: []
        )
        tableSubject.send(table)
        let tab = LensView.TabView(
            tab1: .init(name: "State Before", content: []),
            tab2: .init(name: "State After", content: []),
            tab3: .init(name: "Diff", content: [])
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
            column4: .init(name: "State Before"),
            column5: .init(name: "State After"),
            rows: values.map {
                .init(
                    info1: $0.1.name,
                    info2: $0.1.timestamp.toString(),
                    info3: $0.1.payload,
                    info4: "stateBefore",
                    info5: "stateAfter",
                    id: $0.0
                )
            }
        )
        tableSubject.send(table)
    }
    
    func selectItem(with id: UUID) {
        guard let value = values.first(where: { $0.0 == id }) else { return }
        let tab = LensView.TabView(
            tab1: .init(name: "State Before", content: map(value.1.stateBefore)),
            tab2: .init(name: "State After", content: map(value.1.stateAfter)),
            tab3: .init(name: "Diff", content: [])
        )
        tabSubject.send(tab)
    }
}

extension TAGALens {
    
    func parse(_ value: String) -> TAGAAction {
        let data = value.data(using: .utf8)!
        return try! JSONDecoder().decode(TAGAAction.self, from: data)
    }
    
    func map(_ dict: [String: Any]) -> [LensView.TabView.Content] {
        var contents: [LensView.TabView.Content] = []
        for (key, value) in dict {
            var childrens: [LensView.TabView.Content]? = nil
            var contentValue: LensView.TabView.Value? = nil
            if let value = value as? [String: Any] {
                childrens = map(value)
            } else if let value = value as? [Any] {
                contentValue = .array(value.compactMap(map(primitive:)))
            } else {
                contentValue = .primitive(map(primitive:value))
            }
            contents.append(
                LensView.TabView.Content(
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
