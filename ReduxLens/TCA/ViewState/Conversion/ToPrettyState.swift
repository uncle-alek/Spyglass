import Foundation

extension Dictionary where Key == String, Value: Any {
    
    var prettyPrinted: String {
        let data = try! JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted, .sortedKeys])
        return String(decoding: data, as: UTF8.self)
    }
}
