struct Definitions {
    struct Node {
        enum Kind: String {
            case decl
            case expr
            case stmt
            case type
        }

        init(
            _ kind: Kind,
            _ stem: String,
            _ typeName: String? = nil
        ) {
            self.kind = kind
            self.stem = stem
            self.typeName = typeName ?? Self.defaultTypeName(
                kind: kind, stem: stem
            )
        }

        var kind: Kind
        var stem: String
        var typeName: String

        static func defaultTypeName(kind: Kind, stem: String) -> String {
            return "TS" + stem.pascal + kind.rawValue.pascal
        }
    }

    var nodes: [Node] = [
        .init(.decl, "class"),
        .init(.decl, "field"),
        .init(.decl, "function"),
        .init(.decl, "import"),
        .init(.decl, "interface"),
        .init(.decl, "method"),
        .init(.decl, "namespace"),
        .init(.decl, "sourceFile", "TSSourceFile"),
        .init(.decl, "type"),
        .init(.decl, "var"),
        .init(.expr, "array"),
        .init(.expr, "as"),
        .init(.expr, "assign"),
        .init(.expr, "await"),
        .init(.expr, "booleanLiteral"),
        .init(.expr, "call"),
        .init(.expr, "closure"),
        .init(.expr, "custom"),
        .init(.expr, "ident"),
        .init(.expr, "infixOperator"),
        .init(.expr, "member"),
        .init(.expr, "new"),
        .init(.expr, "nullLiteral"),
        .init(.expr, "numberLiteral"),
        .init(.expr, "object"),
        .init(.expr, "paren"),
        .init(.expr, "postfixOperator"),
        .init(.expr, "prefixOperator"),
        .init(.expr, "stringLiteral"),
        .init(.expr, "subscript"),
        .init(.expr, "templateLiteral"),
        .init(.stmt, "block"),
        .init(.stmt, "case"),
        .init(.stmt, "catch"),
        .init(.stmt, "default"),
        .init(.stmt, "finally"),
        .init(.stmt, "forIn"),
        .init(.stmt, "if"),
        .init(.stmt, "return"),
        .init(.stmt, "switch"),
        .init(.stmt, "throw"),
        .init(.stmt, "try"),
        .init(.type, "array"),
        .init(.type, "custom"),
        .init(.type, "dictionary"),
        .init(.type, "function"),
        .init(.type, "ident"),
        .init(.type, "intersection"),
        .init(.type, "member"),
        .init(.type, "object"),
        .init(.type, "stringLiteral"),
        .init(.type, "union"),
    ]

    var decls: [Node] { nodes.filter { $0.kind == .decl } }
    var exprs: [Node] { nodes.filter { $0.kind == .expr } }
    var stmts: [Node] { nodes.filter { $0.kind == .stmt } }
    var types: [Node] { nodes.filter { $0.kind == .type } }
}




