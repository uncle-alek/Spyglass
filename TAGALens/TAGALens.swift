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
            tab1: .init(name: "State Before", content: ""),
            tab2: .init(name: "State After", content: ""),
            tab3: .init(name: "Diff", content: "")
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
                    info4: $0.1.stateBefore,
                    info5: $0.1.stateAfter,
                    id: $0.0
                )
            }
        )
        tableSubject.send(table)
    }
    
    func selectItem(with id: UUID) {
        guard let value = values.first(where: { $0.0 == id }) else { return }
        let tab = LensView.TabView(
            tab1: .init(name: "State Before", content: value.1.stateBefore),
            tab2: .init(name: "State After", content: value.1.stateAfter),
            tab3: .init(name: "Diff", content: "Here will be diff")
        )
        tabSubject.send(tab)
    }
}

extension TAGALens {
    
    func parse(_ value: String) -> TAGAAction {
        let data = value.data(using: .utf8)!
        return try! JSONDecoder().decode(TAGAAction.self, from: data)
    }
}

extension TimeInterval {
    
    func toString() -> String {
        String(self)
    }
}
