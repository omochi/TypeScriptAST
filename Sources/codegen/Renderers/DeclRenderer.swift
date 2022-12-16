import Foundation

struct DeclRenderer: Renderer {
    static func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "TSDecl.swift"
    }

    var writer: Writer

    func render() throws {
        try writer.withTemplate { (t) in
            t["as"] = asCasts()
        }
    }

    func asCasts() -> String {
        let lines: [String] = definitions.decls.map { (decl) in
            """
public var as\(decl.stem.pascal): \(decl.typeName)? { self as? \(decl.typeName) }
"""
        }
        return lines.joined(separator: "\n")
    }
}
