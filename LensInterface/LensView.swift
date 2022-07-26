//
//  View.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Foundation

enum LensView {

    struct TableView {
        
        struct Row: Identifiable {
            let info1: String
            let info2: String
            let info3: String
            let info4: String
            let info5: String
            let id: UUID
        }
        
        struct Column {
            let name: String
        }
        
        let column1: Column
        let column2: Column
        let column3: Column
        let column4: Column
        let column5: Column
        let rows: [Row]
        
        static let `default` = TableView(
            column1: .init(name: ""),
            column2: .init(name: ""),
            column3: .init(name: ""),
            column4: .init(name: ""),
            column5: .init(name: ""),
            rows: []
        )
    }

    struct TabView {
        
        enum Value {
            case primitive(String)
            case array([String])
        }
        
        struct Content: Identifiable {
            let id = UUID()
            let name: String
            let value: Value?
            let childrens: [Content]?
        }

        
        struct Tab {
            let name: String
            let content: String
        }
        let tab1: Tab
        let tab2: Tab
        let tab3: Tab
        
        static let `default` = TabView(
            tab1: .init(name: "", content: ""),
            tab2: .init(name: "", content: ""),
            tab3: .init(name: "", content: "")
        )
    }
}

var recursiveContent = [LensView.TabView.Content(
    name: "appState",
    value: nil,
    childrens: [
        .init(
            name: "bookingCriteria",
            value: nil,
            childrens: [
                .init(
                    name: "roomName",
                    value: .primitive("My favorite room"),
                    childrens: nil
                ),
                .init(
                    name: "hotelName",
                    value: .primitive("Gooood hotel"),
                    childrens: nil
                )
            ]
        ),
        .init(
            name: "appMetadata",
            value: nil,
            childrens: [
                .init(
                    name: "languageId",
                    value: .primitive("1234"),
                    childrens: nil
                ),
                .init(
                    name: "device",
                    value: .primitive("iPhone"),
                    childrens: nil
                ),
                .init(
                    name: "currency",
                    value: .primitive("USD"),
                    childrens: nil
                )
            ]
        ),
        .init(
            name: "cartState",
            value: nil,
            childrens: [
                .init(
                    name: "cartAddItemsResult",
                    value: nil,
                    childrens: [
                        .init(
                            name: "cartSummary",
                            value: nil,
                            childrens: [
                                .init(
                                    name: "totalItems",
                                    value: .primitive("0"),
                                    childrens: nil
                                ),
                                .init(
                                    name: "activeItems",
                                    value: .primitive("2"),
                                    childrens: nil
                                ),
                                .init(
                                    name: "bookedItems",
                                    value: .primitive("3"),
                                    childrens: nil
                                ),
                                .init(
                                    name: "langinactiveItemsuageId",
                                    value: .primitive("2"),
                                    childrens: nil
                                )
                            ]
                        )
                    ]
                ),
                .init(
                    name: "selectedRoom",
                    value: nil,
                    childrens: [
                        .init(
                            name: "masterRoomName",
                            value: .primitive("Masterrr room"),
                            childrens: nil
                        ),
                        .init(
                            name: "masterRoomNameEnglish",
                            value: .primitive("English name masterrrr room"),
                            childrens: nil
                        )
                    ]
                ),
                .init(
                    name: "searchResult",
                    value: .array(["Moscow", "Bangkok", "London"]),
                    childrens: nil
                )
            ]
        )
    ]
)]
