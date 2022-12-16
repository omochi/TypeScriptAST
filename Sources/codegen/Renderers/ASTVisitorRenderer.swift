import Foundation

struct ASTVisitorRenderer: Renderer {
    static func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "ASTVisitor.swift"
    }

    var writer: Writer

    func render() throws {
        try writer.withTemplate { (t) in
            t["visit"] = visits()
            t["dispatch"] = dispatch()
        }
    }

    func visits() -> String {
        let lines: [String] = definitions.nodes.map { (node) in
            """
open func visit(\(writer.paramLabel(node.stem)): \(node.typeName)) -> Bool { defaultVisitResult }
open func visitPost(\(writer.paramLabel(node.stem)): \(node.typeName)) {}
"""
        }
        return lines.joined(separator: "\n")
    }

    func dispatch() -> String {
        var lines: [String] = []

        lines.append("""
private func dispatch(_ node: any ASTNode) {
    switch node {
"""
        )

        lines += definitions.nodes.map { (node) in
            return """
        case let x as \(node.typeName): visitImpl(\(node.stem): x)
"""
        }

        lines.append("""
    default: break
    }
}
"""
        )

        return lines.joined(separator: "\n")
    }
}
