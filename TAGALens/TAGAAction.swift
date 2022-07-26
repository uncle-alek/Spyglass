//
//  TAGAAction.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 26/7/22.
//

import Foundation

struct TAGAAction: Codable {
    let name: String
    let timestamp: TimeInterval
    let payload: String
    let stateBefore: String
    let stateAfter: String
}
