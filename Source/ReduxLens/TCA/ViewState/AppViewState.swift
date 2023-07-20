import CustomDump
import Foundation
import OrderedCollections

struct AppViewState: Equatable {
    var tableView: LensView.TableView
    var tabView: LensView.TabView
    var sharingHistory: String?
    var error: LensError?
    
    init(_ state: AppState) {
        self.tableView = LensView.TableView(
            column1: .init(name: Strings.Column.action),
            column2: .init(name: Strings.Column.leadTime),
            column3: .init(name: Strings.Column.file),
            column4: .init(name: Strings.Column.line),
            rows: state.events.rows
        )
        self.tabView = LensView.TabView(
            tabs: [
                .init(
                    id: Strings.Tab.diff,
                    name: Strings.Tab.diff,
                    pages: [
                        state.selectedItem.map {
                            .init(
                                id: Strings.Tab.diff + Strings.Tab.raw,
                                name: "",
                                type: .string(text: $0.diff, showRewriteButton: false)
                            )
                        }
                    ].compactMap { $0 }
                ),
                .init(
                    id: Strings.Tab.state,
                    name: Strings.Tab.state,
                    pages: [
                        state.selectedItem.map {
                            .init(
                                id: Strings.Tab.state + Strings.Tab.json,
                                name: Strings.Tab.json,
                                type: .tree(LensView.TabView.TreeNode(Strings.Tree.head, $0.stateAfter))
                            )
                        },
                        state.selectedItem.map {
                            .init(
                                id: Strings.Tab.state + Strings.Tab.raw,
                                name: Strings.Tab.raw,
                                type: .string(text: $0.stateAfter.prettyPrinted, showRewriteButton: true)
                            )
                        }
                    ].compactMap { $0 }
                )
            ]
        )
        self.sharingHistory = state.events.isEmpty ? nil : state.events.sharingData
        self.error = state.error.map(LensError.init(reduxError:))
    }
}
