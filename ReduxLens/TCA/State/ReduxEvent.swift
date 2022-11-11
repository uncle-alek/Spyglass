import Foundation

struct ReduxEvent {
    let name: String
    let leadTime: TimeInterval
    let stateBefore: [String: Any]
    let stateAfter: [String: Any]
    let file: String?
    let line: UInt?
}

extension ReduxEvent: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case leadTime
        case stateBefore
        case stateAfter
        case file
        case line
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        leadTime = try values.decode(TimeInterval.self, forKey: .leadTime)
        file = try values.decodeIfPresent(String.self, forKey: .file)
        line = try values.decodeIfPresent(UInt.self, forKey: .line)
        
        let _stateBeforeString = try values.decode(String.self, forKey: .stateBefore)
        stateBefore = try JSONSerialization.jsonObject(with: Data(_stateBeforeString.utf8), options: []) as! [String : Any]
        let _stateAfterString = try values.decode(String.self, forKey: .stateAfter)
        stateAfter = try JSONSerialization.jsonObject(with: Data(_stateAfterString.utf8), options: []) as! [String : Any]
    }
}

extension ReduxEvent {
    
    static func event(from string: String) -> Result<ReduxEvent, DecodingError> {
        let data = string.data(using: .utf8)!
        do {
            return .success(try JSONDecoder().decode(ReduxEvent.self, from: data))
        } catch {
            return .failure(error as! DecodingError)
        }
    }
}
