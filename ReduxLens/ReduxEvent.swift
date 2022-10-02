//
//  ReduxEvent.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 26/7/22.
//

import Foundation

struct ReduxEvent: Decodable {
    let name: String
    let timestamp: TimeInterval
    let leadTime: TimeInterval
    let stateBefore: [String: Any]
    let stateAfter: [String: Any]
    let file: String?
    let line: UInt?
    
    enum CodingKeys: String, CodingKey {
        case name
        case timestamp
        case leadTime
        case stateBefore
        case stateAfter
        case file
        case line
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        timestamp = try values.decode(TimeInterval.self, forKey: .timestamp)
        leadTime = try values.decode(TimeInterval.self, forKey: .leadTime)
        file = try values.decodeIfPresent(String.self, forKey: .file)
        line = try values.decodeIfPresent(UInt.self, forKey: .line)
        
        let _stateBeforeString = try values.decode(String.self, forKey: .stateBefore)
        stateBefore = try JSONSerialization.jsonObject(with: Data(_stateBeforeString.utf8), options: []) as! [String : Any]
        let _stateAfterString = try values.decode(String.self, forKey: .stateAfter)
        stateAfter = try JSONSerialization.jsonObject(with: Data(_stateAfterString.utf8), options: []) as! [String : Any]
    }
}
