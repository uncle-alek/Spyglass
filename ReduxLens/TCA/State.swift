//
//  State.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import Foundation

struct AppState {
    var events: [(UUID, ReduxEvent)] = []
    var selectedItem: ReduxEvent? = nil
}
