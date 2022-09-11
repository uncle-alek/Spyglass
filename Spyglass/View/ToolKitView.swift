//
//  ToolKitView.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 1/9/22.
//

import AVFoundation
import SwiftUI

struct ToolKitView: View {
    
    @EnvironmentObject var viewStore: ViewStore
    @State var isMusicOn: Bool = true
    let selected: UUID?
    
    var body: some View {
        HStack {
            Button {
                isMusicOn.toggle()
            } label: {
                isMusicOn
                ? Image(systemName: "speaker")
                : Image(systemName: "speaker.slash")
            }
            .help(isMusicOn ? "Turn off sound" : "Turn on sound")
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
            .help("Share events")
            Button {
                viewStore.reset()
            } label: {
                Image(systemName: "trash")
            }
            .help("Delete event history")
            Button {
                guard let selected = selected else { return }
                viewStore.navigateTo(selected)
            } label: {
                Image(systemName: "scope")
            }
            .help("Navigate to IDE")
            .disabled(selected == nil)
        }
        .onChange(of: viewStore.tableView.rows) { rows in
            guard isMusicOn else { return }
            guard !rows.isEmpty else { return }
            AudioServicesPlaySystemSound(1396)
        }
    }
}
