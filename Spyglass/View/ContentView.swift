import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewStore = Spyglass.lensViewStore
    @State var selected: UUID?
    @State var error: LensError?
    
    var body: some View {
        HSplitView {
            CatalogView(selected: $selected)
            TabCabinetView()
        }
        .toolbar {
            ToolKitView(selected: selected)
        }
        .alert(
            isPresented: .constant(viewStore.error != nil),
            error: viewStore.error,
            actions: { _ in Text("Ok") },
            message: { Text($0.failureReason ?? "") }
        )
        .environmentObject(viewStore)
    }
}
