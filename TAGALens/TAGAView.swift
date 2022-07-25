//
//  View.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Foundation

var tv4 = TableView4(
    column1: .init(name: "Action"),
    column2: .init(name: "Thread"),
    column3: .init(name: "Payload"),
    column4: .init(name: "Diff"),
    rows: [
        TableView4.Row(info1: "fetchCartItems", info2: "main", info3: "-", info4: "-"),
        TableView4.Row(info1: "updateCartItems",  info2: "main", info3: "some data", info4: "some diff"),
        TableView4.Row(info1: "didSelectItem", info2: "main", info3: "id = 21444", info4: "some diff"),
        TableView4.Row(info1: "didSelectItem", info2: "main", info3: "id = 28743", info4: "some diff"),
        TableView4.Row(info1: "doBundling", info2: "main", info3: "[id = 21444, id = 28743]", info4: "-"),
        TableView4.Row(info1: "bundlingFailed", info2: "main", info3: "error: Network", info4: "some diff"),
    ]
)
