import Foundation

struct ASTVisitorRenderer: Renderer {
    static func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "ASTVisitor.swift"
    }

    var writer: Writer

    func render() throws {
        try writer.withTemplate { (t) in
            t["visit"] = visit()
            t["dispatch"] = dispatch()
            t["visitImpl"] = visitImpl()
        }
    }

    func visit() -> String {
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

    func visitImpl() -> String {
        let lines = definitions.nodes.map { (node) in
            visitImpl(node: node)
        }

        return lines.joined(separator: "\n\n")
    }

    private func visitImpl(node: Definitions.Node) -> String {
        var lines: [String] = []

        lines.append("""
private func visitImpl(\(writer.paramLabel(node.stem)): \(node.typeName)) {
    guard visit(\(node.stem): \(writer.ident(node.stem))) else { return }
"""
        )

        lines += node.children.map { (child) in
            return """
    walk(\(writer.ident(node.stem)).\(child))
"""
        }

        lines.append("""
    visitPost(\(node.stem): \(writer.ident(node.stem)))
}
"""
        )

        return lines.joined(separator: "\n")
    }
}
