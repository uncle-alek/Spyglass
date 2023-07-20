import Foundation
import OrderedCollections

extension Array where Element == ReduxEvent {
    
    var rows: [LensView.TableView.Row] {
        map { item in
            .init(
                info1: item.name,
                info2: item.leadTime.toString,
                info3: item.toFileAndLine,
                id: item.id
            )
        }
        .reversed()
    }
    
    var sharingData: String {
        map { item in item.name + ", " + item.leadTime.toString + ", " + item.file.toFileName }
        .reversed()
        .joined(separator: "\n")
    }
}

extension TimeInterval {
    
    var toString: String {
        String(format: "%0.1d:%0.3d s", seconds, milliseconds)
    }
    
    var seconds: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    
    var milliseconds: Int {
        Int((self * 1000).truncatingRemainder(dividingBy: 1000))
    }
}

extension ReduxEvent {
    
    var toFileAndLine: String {
        file.toFileName + ":" + line.toLineName
    }
}

extension Optional where Wrapped == String {
    
    var toFileName: String {
        switch self {
        case .some(let value): return String(value.split(separator: "/").last!)
        case .none: return "no file information"
        }
    }
}

extension Optional where Wrapped == UInt {
    
    var toLineName: String {
        switch self {
        case .some(let value): return "\(value)"
        case .none: return "no line information"
        }
    }
}

