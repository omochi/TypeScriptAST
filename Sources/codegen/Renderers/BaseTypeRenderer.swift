import Foundation
import CodegenKit

struct BaseTypeRenderer: Renderer {
    var defs: Definitions

    var fileNames = [
        "TSDecl.swift",
        "TSExpr.swift",
        "TSStmt.swift",
        "TSType.swift"
    ]

    func isTarget(file: URL) -> Bool {
        fileNames.contains(file.lastPathComponent)
    }

    func render(template: inout CodeTemplate, file: URL, on runner: CodegenRunner) throws {
        guard let kind = Node.Kind.allCases.first(where: {
            file.lastPathComponent.lowercased().contains($0.rawValue)
        }) else { return }

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
