//
//  State.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import Foundation

enum ReduxError: Error {
    case navigationFailedFileNotFound
    case navigationFailedLineNotFound
    case eventNotDeserialiazable(DecodingError)
}

struct AppState {
    var events: [(UUID, ReduxEvent)] = []
    var selectedItem: ReduxEvent? = nil
    var error: ReduxError?
}
