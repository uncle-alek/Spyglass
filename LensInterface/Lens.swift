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
    var errorPublisher: AnyPublisher<LensError?, Never> { get }
    var tablePublisher: AnyPublisher<LensView.TableView, Never> { get }
    var tabPublisher: AnyPublisher<LensView.TabView, Never> { get }
    var sharingDataPublisher: AnyPublisher<String?, Never> { get }
    
    func setup()
    func reset()
    func receive(_ value: String)
    func send(_ completion: @escaping (String) -> Void)
    func rewrite(_ value: String)
    func selectItem(with id: UUID)
    func navigateToItem(with id: UUID)
}
