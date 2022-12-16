import Foundation

struct StmtRenderer: Renderer {
    static func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "TSStmt.swift"
    }

    var writer: Writer

    func render() throws {
        try writer.withTemplate { (t) in
            t["as"] = asCasts()
        }
    }

    func asCasts() -> String {
        let lines: [String] = definitions.stmts.map { (stmt) in
            """
public var as\(stmt.stem.pascal): \(stmt.typeName)? { self as? \(stmt.typeName) }
"""
        }
        return lines.joined(separator: "\n")
    }
}
