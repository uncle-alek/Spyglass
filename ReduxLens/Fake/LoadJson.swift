//
//  LoadJson.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import Foundation

func loadJson() -> [String: Any] {
    let path = Bundle.main.path(forResource: "big_state", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
    return try! JSONSerialization.jsonObject(with: data) as! [String: Any]
}
