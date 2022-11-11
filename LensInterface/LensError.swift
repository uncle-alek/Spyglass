import Foundation

struct LensError: LocalizedError, Equatable {
    
    let errorDescription: String?
    let failureReason: String?
}
