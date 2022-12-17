import Foundation
import CodegenKit

struct BaseTypeRenderer: Renderer {
    struct File {
        var name: String
        var kind: Node.Kind
    }

    var defs: Definitions

    var files: [File] = [
        .init(name: "TSDecl.swift", kind: .decl),
        .init(name: "TSExpr.swift", kind: .expr),
        .init(name: "TSStmt.swift", kind: .stmt),
        .init(name: "TSType.swift", kind: .type)
    ]

    func isTarget(file: URL) -> Bool {
        files.contains { $0.name == file.lastPathComponent }
    }

    func render(template: inout CodeTemplate, file: URL, on runner: CodegenRunner) throws {
        let kind = files.first { $0.name == file.lastPathComponent }!.kind

        template["as"] = asCasts(kind: kind)
    }

    func asCasts(kind: Node.Kind) -> String {
        let lines: [String] = defs.nodes.filter { $0.kind == kind }.map { (node) in
            """
public var as\(node.stem.pascal): \(node.typeName)? { self as? \(node.typeName) }
"""
        }
        return lines.joined(separator: "\n")
    }
}
