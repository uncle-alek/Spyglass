//
//  TabView.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 1/9/22.
//

import SwiftUI

struct TabCabinetView: View {
    
    @EnvironmentObject var viewStore: ViewStore
    @State var searchText: String = ""
    @State private var selectedExternalTab = 0
    @State private var selectedInternalTab = 0
    
    var body: some View {
        TabView(selection: $selectedExternalTab) {
            ForEach(Array(viewStore.tabView.tabs.enumerated()), id: \.1) { index, tab in
                Group {
                    if tab.pages.count == 1 {
                        TabPageView(
                            page: tab.pages.first!,
                            searchText: searchText
                        )
                    } else {
                        TabView(selection: $selectedInternalTab) {
                            ForEach(Array(tab.pages.enumerated()), id: \.1) { index, page in
                                TabPageView(
                                    page: page,
                                    searchText: searchText
                                )
                                .tabItem { Text(page.name) }
                                .tag(index)
                            }
                        }
                    }
                }
                .tabItem { Text(tab.name) }
                .tag(index)
            }
        }
        .searchable(text: $searchText)
    }
}

