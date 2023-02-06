import Foundation

func loadBigStateJson() -> [String: Any] {
    let path = Bundle.main.path(forResource: "big_state", ofType: "json")!
    let data = try! Data(contentsOf: URL(fileURLWithPath: path))
    return try! JSONSerialization.jsonObject(with: data) as! [String: Any]
}
