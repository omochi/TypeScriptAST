import Foundation

struct TypeRenderer: Renderer {
    static func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "TSType.swift"
    }

    var writer: Writer

    func render() throws {
        try writer.withTemplate { (t) in
            t["as"] = asCasts()
        }
    }

    func asCasts() -> String {
        let lines: [String] = definitions.types.map { (type) in
            """
public var as\(type.stem.pascal): \(type.typeName)? { self as? \(type.typeName) }
"""
        }
        return lines.joined(separator: "\n")
    }
}
