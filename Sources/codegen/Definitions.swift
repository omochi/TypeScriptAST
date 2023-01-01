struct Node {
    enum Kind: String, CaseIterable {
        case node
        case decl
        case expr
        case stmt
        case type
    }

    init(
        _ kind: Kind,
        _ stem: String,
        typeName: String? = nil,
        children: [String] = []
    ) {
        self.kind = kind
        self.stem = stem
        self.typeName = typeName ?? Self.defaultTypeName(
            kind: kind, stem: stem
        )
        self.children = children
    }

    var kind: Kind
    var stem: String
    var typeName: String
    var children: [String]

    static func defaultTypeName(kind: Kind, stem: String) -> String {
        return "TS" + stem.pascal + kind.rawValue.pascal
    }
}

struct Definitions {
    var nodes: [Node] = [
        .init(.node, "typeParameter", children: [
            "constraint", "default"
        ]),
        .init(.decl, "class", children: [
            "genericParams", "extends", "implements", "body"
        ]),
        .init(.decl, "custom"),
        .init(.decl, "field", children: [
            "type"
        ]),
        .init(.decl, "function", children: [
            "genericParams", "params", "result", "body"
        ]),
        .init(.decl, "import"),
        .init(.decl, "index", children: [
            "index", "value"
        ]),
        .init(.decl, "interface", children: [
            "genericParams", "extends", "body"
        ]),
        .init(.decl, "method", children: [
            "genericParams", "params", "result", "body"
        ]),
        .init(.decl, "namespace", children: [
            "body"
        ]),
        .init(.decl, "sourceFile", typeName: "TSSourceFile", children: [
            "elements"
        ]),
        .init(.decl, "type", children: [
            "genericParams", "type"
        ]),
        .init(.decl, "var", children: [
            "type", "initializer"
        ]),
        .init(.expr, "array", children: [
            "elements"
        ]),
        .init(.expr, "as", children: [
            "expr", "type"
        ]),
        .init(.expr, "assign", children: [
            "lhs", "rhs"
        ]),
        .init(.expr, "await", children: [
            "expr"
        ]),
        .init(.expr, "booleanLiteral"),
        .init(.expr, "call", children: [
            "callee", "genericArgs", "args"
        ]),
        .init(.expr, "closure", children: [
            "genericParams", "params", "result", "body"
        ]),
        .init(.expr, "custom"),
        .init(.expr, "ident"),
        .init(.expr, "infixOperator", children: [
            "lhs", "rhs"
        ]),
        .init(.expr, "member", children: [
            "base"
        ]),
        .init(.expr, "new", children: [
            "callee", "args"
        ]),
        .init(.expr, "nullLiteral"),
        .init(.expr, "numberLiteral"),
        .init(.expr, "object", children: [
            "fields"
        ]),
        .init(.expr, "paren", children: [
            "expr"
        ]),
        .init(.expr, "postfixOperator", children: [
            "expr"
        ]),
        .init(.expr, "prefixOperator", children: [
            "expr"
        ]),
        .init(.expr, "stringLiteral"),
        .init(.expr, "subscript"),
        .init(.expr, "templateLiteral", children: [
            "substitutions"
        ]),
        .init(.stmt, "block", children: [
            "elements"
        ]),
        .init(.stmt, "case", children: [
            "expr", "elements"
        ]),
        .init(.stmt, "catch", children: [
            "body"
        ]),
        .init(.stmt, "default", children: [
            "elements"
        ]),
        .init(.stmt, "finally", children: [
            "body"
        ]),
        .init(.stmt, "forIn", children: [
            "expr", "body"
        ]),
        .init(.stmt, "if", children: [
            "condition", "then", "else"
        ]),
        .init(.stmt, "return", children: [
            "expr"
        ]),
        .init(.stmt, "switch", children: [
            "expr", "cases"
        ]),
        .init(.stmt, "throw", children: [
            "expr"
        ]),
        .init(.stmt, "try", children: [
            "body"
        ]),
        .init(.type, "array", children: [
            "element"
        ]),
        .init(.type, "conditional", children: [
            "check", "extends", "true", "false"
        ]),
        .init(.type, "custom"),
        .init(.type, "function", children: [
            "genericParams", "params", "result"
        ]),
        .init(.type, "ident", children: [
            "genericArgs"
        ]),
        .init(.type, "indexedAccess", children: [
            "base", "index"
        ]),
        .init(.type, "infer"),
        .init(.type, "intersection", children: [
            "elements"
        ]),
        .init(.type, "keyof", children: [
            "type"
        ]),
        .init(.type, "mapped", children: [
            "constraint", "nameType", "value"
        ]),
        .init(.type, "member", children: [
            "base", "genericArgs"
        ]),
        .init(.type, "numberLiteral"),
        .init(.type, "object", children: [
            "fields"
        ]),
        .init(.type, "stringLiteral"),
        .init(.type, "tuple", children: [
            "elements"
        ]),
        .init(.type, "union", children: [
            "elements"
        ]),
    ]

    var decls: [Node] { nodes.filter { $0.kind == .decl } }
    var exprs: [Node] { nodes.filter { $0.kind == .expr } }
    var stmts: [Node] { nodes.filter { $0.kind == .stmt } }
    var types: [Node] { nodes.filter { $0.kind == .type } }
}




