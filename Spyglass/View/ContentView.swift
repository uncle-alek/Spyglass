//
//  ContentView.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import AVFoundation
import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewStore = Spyglass.viewStore
    @State var selected: UUID?
    @State var searchText: String = ""
    @State private var selectedExternalTab = 0
    @State private var selectedInternalTab = 0
    @State var ranges: [NSRange] = []
    @State var currentIndex: Int = 0
    @State var isMusicOn: Bool = true
        
    var body: some View {
        HStack {
            Table(
                viewStore.tableView.rows,
                selection: Binding(
                    get: { selected },
                    set: {
                        self.selected = $0
                        guard let selected = selected else { return }
                        viewStore.select(selected)
                    }
                )
            ) {
                TableColumn(viewStore.tableView.column1.name, value: \.info1)
                TableColumn(viewStore.tableView.column2.name, value: \.info2)
            }
            .onChange(of: viewStore.tableView.rows) { rows in
                guard isMusicOn else { return }
                guard !rows.isEmpty else { return }
                AudioServicesPlaySystemSound(1396)
            }
            .animation(.easeInOut, value: viewStore.tableView.rows.count)
            
            
            TabView(selection: $selectedExternalTab) {
                ForEach(Array(viewStore.tabView.tabs.enumerated()), id: \.1) { index, tab in
                    Group {
                        if tab.pages.count == 1 {
                            TabPageView(
                                page: tab.pages.first!,
                                searchText: searchText,
                                ranges: $ranges,
                                currentIndex: currentIndex
                            )
                        } else {
                            TabView(selection: $selectedInternalTab) {
                                ForEach(Array(tab.pages.enumerated()), id: \.1) { index, page in
                                    TabPageView(
                                        page: page,
                                        searchText: searchText,
                                        ranges: $ranges,
                                        currentIndex: currentIndex
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
            .onChange(of: selectedExternalTab) { _ in
                ranges = []
                currentIndex = 0
            }
            .onChange(of: ranges) { _ in
                currentIndex = 0
            }
// MARK: Under construction
//          .searchable(text: $searchText)
        }
        .toolbar {
            Button{
                isMusicOn.toggle()
            } label: {
                isMusicOn
                ? Image(systemName: "speaker")
                : Image(systemName: "speaker.slash")
            }
            Menu {
                Button {
                    guard let data = viewStore.sharingData else { return }
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(data, forType: .string)
                } label: {
                    Text("copy all actions")
                }
                .disabled(viewStore.sharingData == nil)
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            Button {
                viewStore.reset()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            Button {
                guard let selected = selected else { return }
                viewStore.navigateTo(selected)
            } label: {
                Image(systemName: "scope")
            }
            .disabled(selected == nil)
            
            Spacer()
// MARK: Under construction
//            Button {
//                currentIndex = (currentIndex + 1) % ranges.count
//            } label: {
//                Text("Find")
//            }
//            .disabled(ranges.isEmpty)
//            Button {
//                currentIndex = (currentIndex - 1) % ranges.count
//                currentIndex = currentIndex < 0 ? ranges.count + currentIndex : currentIndex
//            } label: {
//                Text("Find Prev")
//            }
//            .disabled(ranges.isEmpty)
        }
    }
}
