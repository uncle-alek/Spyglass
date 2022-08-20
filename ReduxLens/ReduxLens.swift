//
//  TAGALens.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Combine
import CustomDump
import Foundation

final class ReduxLens: Lens {
    
    var tablePublisher: AnyPublisher<LensView.TableView, Never> { tableSubject.eraseToAnyPublisher() }
    var tabPublisher: AnyPublisher<LensView.TabView, Never> { tabSubject.eraseToAnyPublisher() }
    var sharingData: AnyPublisher<String?, Never> { sharingDataSubject.eraseToAnyPublisher() }
    var connectionPath: String { "redux" }
    
    private var events: [(UUID, ReduxEvent)] = []
    private let tableSubject = PassthroughSubject<LensView.TableView, Never>()
    private let tabSubject = PassthroughSubject<LensView.TabView, Never>()
    private let sharingDataSubject = PassthroughSubject<String?, Never>()

    func setup() {
        let table = LensView.TableView(
            column1: .init(name: "Action"),
            column2: .init(name: "Timestamp"),
            rows: []
        )
        tableSubject.send(table)
        let tab = LensView.TabView(
            tabs: [
                .init(name: "States Diff", pages: []),
                .init(name: "State Before", pages: []),
                .init(name: "State After", pages: [])
            ]
        )
        tabSubject.send(tab)
    }
    
    func reset() {
        let table = LensView.TableView(
            column1: .init(name: "Action"),
            column2: .init(name: "Timestamp"),
            rows: []
        )
        tableSubject.send(table)
        let tab = LensView.TabView(
            tabs: [
                .init(name: "States Diff", pages: []),
                .init(name: "State Before", pages: []),
                .init(name: "State After", pages: [])
            ]
        )
        tabSubject.send(tab)
        events = []
    }
    
    func receive(_ value: String) {
        let action = parse(value)
        events.append((UUID(), action))
        let table = LensView.TableView(
            column1: .init(name: "Action"),
            column2: .init(name: "Timestamp"),
            rows: map(events)
        )
        tableSubject.send(table)
    }
    
    func selectItem(with id: UUID) {
        guard let event = events.first(where: { $0.0 == id }) else { return }
        let tab = LensView.TabView(
            tabs: [
                .init(name: "States Diff", pages: [
                    .init(name: "", type: .string(diff(for: event.1)))
                ]),
                .init(name: "State Before", pages: [
                    .init(name: "JSON", type: .tree(map(event.1.stateBefore))),
                    .init(name: "Raw", type: .string(prettyPrinted(state: event.1.stateBefore)))
                ]),
                .init(name: "State After", pages: [
                    .init(name: "JSON", type: .tree(map(event.1.stateAfter))),
                    .init(name: "Raw", type: .string(prettyPrinted(state: event.1.stateAfter)))
                ])
            ]
        )
        tabSubject.send(tab)
    }
    
    func navigateToItem(with id: UUID) {
        guard let event = events.first(where: { $0.0 == id }) else { return }
        guard let file = event.1.file else { return }
        guard let line = event.1.line else { return }
        
        DispatchQueue.global().async {
            shell("xed", "-x", file)
            shell("xed", "-x", "-l", String(line))
        }
    }
    
    func shareHistory() {
        sharingDataSubject.send(sharingData(for: events))
    }
}

extension ReduxLens {
    
    func parse(_ value: String) -> ReduxEvent {
        let data = value.data(using: .utf8)!
        return try! JSONDecoder().decode(ReduxEvent.self, from: data)
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

    func map(_ events: [(UUID, ReduxEvent)]) -> [LensView.TableView.Row] {
        zip(
            timestampDiff(for: events),
            events
        ).map { timeStamp, event in
            LensView.TableView.Row.init(
                info1: event.1.name,
                info2: timeStamp.toString(),
                id: event.0
            )
        }.reversed()
    }
    
    func sharingData(for events: [(UUID, ReduxEvent)]) -> String {
        zip(
            events,
            timestampDiff(for: events)
        )
        .map { $0.1.name + ", " + $1.toString() }
        .reversed()
        .joined(separator: "\n")
    }
    
    func timestampDiff(for events: [(UUID, ReduxEvent)]) -> [TimeInterval] {
        [0] + zip(events.dropFirst(), events.dropLast()).map { $0.1.timestamp - $1.1.timestamp }
    }
    
    func diff(for event: ReduxEvent) -> String {
        CustomDump.diff(
            event.stateBefore,
            event.stateAfter,
            format: .init(first: "\u{274C}", second: "\u{2705}", both: " ")
        ) ?? "no changes..."
    }
    
    func prettyPrinted(state: [String: Any]) -> String {
        let data = try! JSONSerialization.data(withJSONObject: state, options: [.prettyPrinted, .sortedKeys])
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

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}
