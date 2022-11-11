import Foundation

final class ReduxLensBuilder: LensBuilder {
    
    override init() {}
    
    override func build() -> Lens {
        ReduxLens()
    }
}
