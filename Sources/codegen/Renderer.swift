import Foundation

protocol Renderer {
    static func isTarget(file: URL) -> Bool

    init(writer: Writer)

    var writer: Writer { get }

    func render() throws
}

extension Renderer {
    var definitions: Definitions {
        writer.definitions
    }
}
