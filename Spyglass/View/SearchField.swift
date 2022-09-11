//
//  TextDebouncer.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 1/9/22.
//

import SwiftUI

struct SearchField: View {

    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField(
                "Search",
                text: $searchText
            )
            .cornerRadius(12)
            .disableAutocorrection(true)
        }
    }
}
