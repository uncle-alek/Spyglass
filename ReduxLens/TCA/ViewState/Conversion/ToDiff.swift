import CustomDump

extension ReduxEvent {
    
    var diff: String {
        CustomDump.diff(
            self.stateBefore,
            self.stateAfter,
            format: .init(first: Strings.Diff.removed, second: Strings.Diff.added, both: " ")
        ) ?? Strings.Diff.noChanges
    }
}
