//
//  LensInterface.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Combine
import Foundation

protocol Lens {
    
    var connectionPath: String { get }
    var viewPublisher: AnyPublisher<TableView4, Never> { get }
    
    func setup()
    func loop(with value: String)
}
