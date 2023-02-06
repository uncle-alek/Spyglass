import Foundation

extension LensError {
    
    init(
        reduxError: ReduxError
    ) {
        self.errorDescription = reduxError.errorDescription
        self.failureReason = reduxError.failureReason
    }
}

extension ReduxError {
    
    var errorDescription: String {
        switch self {
        case .navigationFailedFileNotFound:
            return "Failed to navigate to IDE"
        case .navigationFailedLineNotFound:
            return "Failed to navigate to IDE"
        case .eventNotDeserialiazable:
            return "Failed to deserialize event"
        }
    }
    
    var failureReason: String {
        switch self {
        case .navigationFailedFileNotFound:
            return "File name not found"
        case .navigationFailedLineNotFound:
            return "File line not found"
        case .eventNotDeserialiazable(let decodingError):
            switch decodingError {
            case let .typeMismatch(type, _):
                return "Type '\(type)' mismatch"
            case let .valueNotFound(value, _):
                return "Value '\(value)' not found"
            case let .keyNotFound(key, _):
                return "Key '\(key)' not found"
            case .dataCorrupted(_):
                return "Corrupted date"
            @unknown default:
                return "Unknown reason"
            }
        }
    }
}
