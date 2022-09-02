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
                .padding(.leading)
            TextField(
                "Enter a search name...",
                text: $searchText
            )
            .cornerRadius(12)
            .disableAutocorrection(true)
            .padding(.trailing)
        }.frame(minHeight: 44, idealHeight: 44)
            .background(Color.black.opacity(0.05))
            .cornerRadius(12)
            .padding([.leading, .trailing])
    }
}
