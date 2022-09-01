//
//  TabView.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 1/9/22.
//

import SwiftUI

struct TabCabinetView: View {
    
    @EnvironmentObject var viewStore: ViewStore
    @StateObject var textDebouncer = TextDebouncer(delay: .milliseconds(500))
    @State private var selectedExternalTab = 0
    @State private var selectedInternalTab = 0
    
    var body: some View {
        TabView(selection: $selectedExternalTab) {
            ForEach(Array(viewStore.tabView.tabs.enumerated()), id: \.1) { index, tab in
                Group {
                    if tab.pages.count == 1 {
                        TabPageView(
                            page: tab.pages.first!,
                            searchText: textDebouncer.debouncedText
                        )
                    } else {
                        TabView(selection: $selectedInternalTab) {
                            ForEach(Array(tab.pages.enumerated()), id: \.1) { index, page in
                                TabPageView(
                                    page: page,
                                    searchText: textDebouncer.debouncedText
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
        .searchable(text: $textDebouncer.searchText)
    }
}
