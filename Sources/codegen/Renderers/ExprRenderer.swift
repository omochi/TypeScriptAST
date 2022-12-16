import Foundation

struct ExprRenderer: Renderer {
    static func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "TSExpr.swift"
    }

    var writer: Writer

    func render() throws {
        try writer.withTemplate { (t) in
            t["as"] = asCasts()
        }
    }

    func asCasts() -> String {
        let lines: [String] = definitions.exprs.map { (expr) in
            """
public var as\(expr.stem.pascal): \(expr.typeName)? { self as? \(expr.typeName) }
"""
        }
        return lines.joined(separator: "\n")
    }
}
