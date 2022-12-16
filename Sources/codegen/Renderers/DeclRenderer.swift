import Foundation
import CodeTemplate

struct DeclRenderer: Renderer {
    init?(definitions: Definitions, file: URL) {
        guard file.lastPathComponent == "TSDecl.swift" else { return nil }
        self.definitions = definitions
        self.file = file
    }

    var definitions: Definitions
    var file: URL

    func render() throws {
        var template = try Template(file: file)
        template["as"] = asCasts()
        try template.description.write(to: file, atomically: true, encoding: .utf8)
    }

    func asCasts() -> String {
        let lines: [String] = definitions.decls.map { (decl) in
            """
public var as\(decl.stem.capitalized): \(decl.typeName)? { self as? \(decl.typeName) }
"""
        }
        return lines.joined(separator: "\n")
    }
}
