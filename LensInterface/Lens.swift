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
    var tablePublisher: AnyPublisher<LensView.TableView, Never> { get }
    var tabPublisher: AnyPublisher<LensView.TabView, Never> { get }
    
    func setup()
    func receive(_ value: String)
    func selectItem(with id: UUID)
}
