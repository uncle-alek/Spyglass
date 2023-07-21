import SwiftUI

struct CatalogView: View {
    
    @EnvironmentObject var viewStore: LensViewStore
    @Binding var selected: String?
    
    var body: some View {
        Table(
            selection: Binding(
                get: { selected },
                set: {
                    self.selected = $0
                    guard let selected = selected else { return }
                    viewStore.select(selected)
                }
            )
        ) {
            TableColumn(viewStore.tableView.column1.name) {
                Text($0.info1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background($0.background != nil ? $0.background!.toSwiftUIColor : .clear)
                    .textSelection(.enabled)
            }
            TableColumn(viewStore.tableView.column2.name) {
                Text($0.info2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background($0.background != nil ? $0.background!.toSwiftUIColor : .clear)
                    .textSelection(.enabled)
            }
            TableColumn(viewStore.tableView.column3.name) {
                Text($0.info3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background($0.background != nil ? $0.background!.toSwiftUIColor : .clear)
                    .textSelection(.enabled)
            }
        } rows: {
            ForEach(viewStore.tableView.rows, id: \.id) {
                TableRow($0)
            }
        }
        .animation(.easeInOut, value: viewStore.tableView.rows.count)
    }
}

extension LensView.TableView.Row.Color {
    
    var toSwiftUIColor: SwiftUI.Color {
        Color(
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue:  Double(blue) / 255
        )
    }
}
