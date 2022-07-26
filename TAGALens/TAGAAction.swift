//
//  TAGAAction.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 26/7/22.
//

import Foundation

struct TAGAAction: Decodable {
    let name: String
    let timestamp: TimeInterval
    let payload: String
    let stateBefore: [String: Any]
    let stateAfter: [String: Any]
    
    enum CodingKeys: String, CodingKey {
        case name
        case timestamp
        case payload
        case stateBefore
        case stateAfter
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        timestamp = try values.decode(TimeInterval.self, forKey: .timestamp)
        payload = try values.decode(String.self, forKey: .payload)
        
        let stateBeforeString = try values.decode(String.self, forKey: .stateBefore)
        stateBefore = try JSONSerialization.jsonObject(with: Data(stateBeforeString.utf8), options: []) as! [String : Any]
        let stateAfterString = try values.decode(String.self, forKey: .stateAfter)
        stateAfter = try JSONSerialization.jsonObject(with: Data(stateAfterString.utf8), options: []) as! [String : Any]
    }
}
