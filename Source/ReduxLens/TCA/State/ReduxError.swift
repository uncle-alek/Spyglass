import Foundation

enum ReduxError: Error {
    case navigationFailedFileNotFound
    case navigationFailedLineNotFound
    case eventNotDeserialiazable(DecodingError)
}
