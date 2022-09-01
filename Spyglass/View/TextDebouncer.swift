//
//  TextDebouncer.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 1/9/22.
//

import SwiftUI

final class TextDebouncer : ObservableObject {

    @Published var debouncedText = ""
    @Published var searchText = ""

    init(delay: DispatchQueue.SchedulerTimeType.Stride) {
        $searchText
            .debounce(for: delay, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .assign(to: &$debouncedText)
    }
}
