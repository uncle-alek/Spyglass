//
//  TAGABuilder.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Foundation

final class TAGALensBuilder: LensBuilder {
    
    override init() {}
    
    override func build() -> Lens {
        TAGALens()
    }
}
