import Foundation
import OrderedCollections

extension OrderedDictionary where Key == UUID, Value == ReduxEvent {
    
    var rows: [LensView.TableView.Row] {
        map { k, v in .init(info1: v.name, info2: v.leadTime.toString(), info3: v.file.toFileName, id: k)}
        .reversed()
    }
    
    var sharingData: String {
        map { _, v in v.name + ", " + v.leadTime.toString() + ", " + v.file.toFileName }
        .reversed()
        .joined(separator: "\n")
    }
}

extension TimeInterval {
    
    func toString() -> String {
        String(format: "%0.1d:%0.3d s", seconds, milliseconds)
    }
    
    var seconds: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
    
    var milliseconds: Int {
        Int((self * 1000).truncatingRemainder(dividingBy: 1000))
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

