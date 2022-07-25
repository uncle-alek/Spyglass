//
//  LensLoader.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 25/7/22.
//

import Foundation

typealias InitFunction = @convention(c) () -> UnsafeMutableRawPointer

func plugin(at path: String) -> Lens {
    let openRes = dlopen(path, RTLD_NOW|RTLD_LOCAL)
    if openRes != nil {
        defer {
            dlclose(openRes)
        }

        let symbolName = "createPlugin"
        let sym = dlsym(openRes, symbolName)

        if sym != nil {
            let f: InitFunction = unsafeBitCast(sym, to: InitFunction.self)
            let pluginPointer = f()
            let builder = Unmanaged<LensBuilder>.fromOpaque(pluginPointer).takeRetainedValue()
            return builder.build()
        }
        else {
            fatalError("error loading lib: symbol \(symbolName) not found, path: \(path)")
        }
    }
    else {
        if let err = dlerror() {
            fatalError("error opening lib: \(String(format: "%s", err)), path: \(path)")
        }
        else {
            fatalError("error opening lib: unknown error, path: \(path)")
        }
    }
}
