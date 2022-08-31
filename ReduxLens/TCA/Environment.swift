//
//  Environment.swift
//  Spyglass
//
//  Created by Aleksey Yakimenko on 31/8/22.
//

import Foundation

var appEnvironment = AppEnvironment(shell: shell)

struct AppEnvironment {
    var shell: (String...) -> Int32
}

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}
