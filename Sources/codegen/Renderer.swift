import Foundation

protocol Renderer {
    init?(definitions: Definitions, file: URL)

    func render() throws
}
