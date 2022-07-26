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
        
        struct Content: Identifiable {
            let id = UUID()
            let name: String
            let data: [String]
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
    data: [],
    childrens: [
        .init(
            name: "bookingCriteria",
            data: [
                "roomName: My favorite room",
                "hotelName: Gooood hotel"
            ],
            childrens: nil
        ),
        .init(
            name: "appMetadata",
            data: [
                "languageId: 1234",
                "device: iPhone",
                "currency: USD"
            ],
            childrens: nil
        ),
        .init(
            name: "cartState",
            data: [],
            childrens: [
                .init(
                    name: "cartAddItemsResult",
                    data: [],
                    childrens: [
                        .init(
                            name: "cartSummary",
                            data: [
                                "totalItems: 0",
                                "activeItems: 2",
                                "bookedItems: 3",
                                "inactiveItems: 2"
                            ],
                            childrens: nil
                        )
                    ]
                ),
                .init(
                    name: "selectedRoom",
                    data: [
                        "masterRoomName: Masterrr room",
                        "masterRoomNameEnglish: English name masterrrr room"
                    ],
                    childrens: nil
                ),
                .init(
                    name: "searchResult",
                    data: [],
                    childrens: []
                )
            ]
        )
    ]
)]
