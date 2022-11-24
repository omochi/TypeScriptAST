public protocol ASTVisitor {
    func visit(_ node: any ASTNode)

    func visit(decl: any TSDecl)
    func visit(class: TSClassDecl)
    func visit(field: TSFieldDecl)
    func visit(function: TSFunctionDecl)
    func visit(import: TSImportDecl)
    func visit(interface: TSInterfaceDecl)
    func visit(method: TSMethodDecl)
    func visit(namespace: TSNamespaceDecl)
    func visit(type: TSTypeDecl)
    func visit(`var`: TSVarDecl)

    func visit(expr: any TSExpr)
    func visit(numberLiteral: TSNumberLiteralExpr)

    func visit(stmt: any TSStmt)
    func visit(block: TSBlockStmt)
    func visit(return: TSReturnStmt)

    func visit(type: any TSType)
    func visit(array: TSArrayType)
    func visit(custom: TSCustomType)
    func visit(dictionary: TSDictionaryType)
    func visit(function: TSFunctionType)
    func visit(named: TSNamedType)
    func visit(nested: TSNestedType)
    func visit(record: TSRecordType)
    func visit(stringLiteral: TSStringLiteralType)
    func visit(union: TSUnionType)
}

extension ASTVisitor {
    public func visit(_ node: any ASTNode) {
        switch node {
        case let x as TSClassDecl:
            visit(class: x)
        case let x as TSFieldDecl:
            visit(field: x)
        case let x as TSFunctionDecl:
            visit(function: x)
        case let x as TSImportDecl:
            visit(import: x)
        case let x as TSInterfaceDecl:
            visit(interface: x)
        case let x as TSMethodDecl:
            visit(method: x)
        case let x as TSNamespaceDecl:
            visit(namespace: x)
        case let x as TSTypeDecl:
            visit(type: x)
        case let x as TSVarDecl:
            visit(var: x)
        case let x as TSNumberLiteralExpr:
            visit(numberLiteral: x)
        case let x as TSBlockStmt:
            visit(block: x)
        case let x as TSReturnStmt:
            visit(return: x)
        case let x as TSArrayType:
            visit(array: x)
        case let x as TSCustomType:
            visit(custom: x)
        case let x as TSDictionaryType:
            visit(dictionary: x)
        case let x as TSFunctionType:
            visit(function: x)
        case let x as TSNamedType:
            visit(named: x)
        case let x as TSNestedType:
            visit(nested: x)
        case let x as TSRecordType:
            visit(record: x)
        case let x as TSStringLiteralType:
            visit(stringLiteral: x)
        case let x as TSUnionType:
            visit(union: x)
        default:
            break
        }
    }

    public func visit(decl: any TSDecl) {}
    public func visit(class: TSClassDecl) { visit(decl: `class`) }
    public func visit(field: TSFieldDecl) { visit(decl: field) }
    public func visit(function: TSFunctionDecl) { visit(decl: function) }
    public func visit(import: TSImportDecl) { visit(decl: `import`) }
    public func visit(interface: TSInterfaceDecl) { visit(decl: interface) }
    public func visit(method: TSMethodDecl) { visit(decl: method) }
    public func visit(namespace: TSNamespaceDecl) { visit(decl: namespace) }
    public func visit(type: TSTypeDecl) { visit(decl: type) }
    public func visit(`var`: TSVarDecl) { visit(decl: `var`) }

    public func visit(expr: any TSExpr) {}
    public func visit(numberLiteral: TSNumberLiteralExpr) { visit(expr: numberLiteral) }

    public func visit(stmt: any TSStmt) {}
    public func visit(block: TSBlockStmt) { visit(stmt: block) }
    public func visit(return: TSReturnStmt) { visit(stmt: `return`) }

    public func visit(type: any TSType) {}
    public func visit(array: TSArrayType) { visit(type: array) }
    public func visit(custom: TSCustomType) { visit(type: custom) }
    public func visit(dictionary: TSDictionaryType) { visit(type: dictionary) }
    public func visit(function: TSFunctionType) { visit(type: function) }
    public func visit(named: TSNamedType) { visit(type: named) }
    public func visit(nested: TSNestedType) { visit(type: nested) }
    public func visit(record: TSRecordType) { visit(type: record) }
    public func visit(stringLiteral: TSStringLiteralType) { visit(type: stringLiteral) }
    public func visit(union: TSUnionType) { visit(type: union) }
}
