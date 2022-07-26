//
//  TAGALens.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Combine
import Foundation

final class TAGALens: Lens {
    
    var viewPublisher: AnyPublisher<TableView4, Never> { viewSubject.eraseToAnyPublisher() }
    var connectionPath: String { "echo" }
    
    private var values: [String] = []
    private let viewSubject = PassthroughSubject<TableView4, Never>()
    
    func setup() {
        let table = TableView4(
            column1: .init(name: "Action"),
            column2: .init(name: "Thread"),
            column3: .init(name: "Payload"),
            column4: .init(name: "Defference"),
            rows: []
        )
        viewSubject.send(table)
    }
    
    func loop(with value: String) {
        values.append(value)
        let table = TableView4(
            column1: .init(name: "Action"),
            column2: .init(name: "Thread"),
            column3: .init(name: "Payload"),
            column4: .init(name: "Defference"),
            rows: values.map {
                .init(
                    info1: $0,
                    info2: "",
                    info3: "",
                    info4: ""
                )
            }
        )
        viewSubject.send(table)
    }
}
