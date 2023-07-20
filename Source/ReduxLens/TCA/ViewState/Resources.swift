import Foundation

enum Strings {
    enum Column {
        static let action = "Action"
        static let leadTime = "Lead Time"
        static let file = "File"
    }
    enum Tab {
        static let diff = "Diff"
        static let state = "State"
        static let json = "JSON"
        static let raw = "Raw"
    }
    enum Tree {
        static let head = "AppState"
    }
    enum Diff {
        static let noChanges = "no changes..."
        static let removed = "\u{274C}"
        static let added = "\u{2705}"
    }
}
