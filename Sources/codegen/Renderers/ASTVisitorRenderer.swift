import Foundation
import CodegenKit

struct ASTVisitorRenderer: Renderer {
    var defs: Definitions
    var writer = SwiftWriter()

    func isTarget(file: URL) -> Bool {
        file.lastPathComponent == "ASTVisitor.swift"
    }

    func render(template: inout CodeTemplate, file: URL, on runner: CodegenRunner) throws {
        template["visit"] = visit()
        template["dispatch"] = dispatch()
        template["visitImpl"] = visitImpl()
    }

    func visit() -> String {
        let lines: [String] = defs.nodes.map { (node) in
            """
open func visit(\(writer.ident(node.stem)): \(node.typeName)) -> Bool { defaultVisitResult }
open func visitPost(\(writer.ident(node.stem)): \(node.typeName)) {}
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

        lines += defs.nodes.map { (node) in
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
        let lines = defs.nodes.map { (node) in
            visitImpl(node: node)
        }

        return lines.joined(separator: "\n\n")
    }

    private func visitImpl(node: Node) -> String {
        var lines: [String] = []

        lines.append("""
private func visitImpl(\(writer.ident(node.stem)): \(node.typeName)) {
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
