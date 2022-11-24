public protocol ASTVisitor {
    func visit(_ node: any ASTNode)

    func visit(class: TSClassDecl)
    func visit(field: TSFieldDecl)
    func visit(function: TSFunctionDecl)
    func visit(import: TSImportDecl)
    func visit(interface: TSInterfaceDecl)
    func visit(method: TSMethodDecl)
    func visit(namespace: TSNamespaceDecl)
    func visit(sourceFile: TSSourceFile)
    func visit(type: TSTypeDecl)
    func visit(`var`: TSVarDecl)

    func visit(as: TSAsExpr)
    func visit(call: TSCallExpr)
    func visit(ident: TSIdentExpr)
    func visit(infixOperator: TSInfixOperatorExpr)
    func visit(new: TSNewExpr)
    func visit(numberLiteral: TSNumberLiteralExpr)
    func visit(paren: TSParenExpr)
    func visit(prefixOperator: TSPrefixOperatorExpr)
    func visit(stringLiteral: TSStringLiteralExpr)

    func visit(block: TSBlockStmt)
    func visit(forIn: TSForInStmt)
    func visit(if: TSIfStmt)
    func visit(return: TSReturnStmt)
    func visit(throw: TSThrowStmt)

    func visit(array: TSArrayType)
    func visit(custom: TSCustomType)
    func visit(dictionary: TSDictionaryType)
    func visit(function: TSFunctionType)
    func visit(ident: TSIdentType)
    func visit(member: TSMemberType)
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
        case let x as TSSourceFile:
            visit(sourceFile: x)
        case let x as TSTypeDecl:
            visit(type: x)
        case let x as TSVarDecl:
            visit(var: x)
        case let x as TSAsExpr:
            visit(as: x)
        case let x as TSCallExpr:
            visit(call: x)
        case let x as TSIdentExpr:
            visit(ident: x)
        case let x as TSInfixOperatorExpr:
            visit(infixOperator: x)
        case let x as TSNewExpr:
            visit(new: x)
        case let x as TSNumberLiteralExpr:
            visit(numberLiteral: x)
        case let x as TSParenExpr:
            visit(paren: x)
        case let x as TSPrefixOperatorExpr:
            visit(prefixOperator: x)
        case let x as TSStringLiteralExpr:
            visit(stringLiteral: x)
        case let x as TSBlockStmt:
            visit(block: x)
        case let x as TSForInStmt:
            visit(forIn: x)
        case let x as TSIfStmt:
            visit(if: x)
        case let x as TSReturnStmt:
            visit(return: x)
        case let x as TSThrowStmt:
            visit(throw: x)
        case let x as TSArrayType:
            visit(array: x)
        case let x as TSCustomType:
            visit(custom: x)
        case let x as TSDictionaryType:
            visit(dictionary: x)
        case let x as TSFunctionType:
            visit(function: x)
        case let x as TSIdentType:
            visit(ident: x)
        case let x as TSMemberType:
            visit(member: x)
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

    public func visit(class: TSClassDecl) {}
    public func visit(field: TSFieldDecl) {}
    public func visit(function: TSFunctionDecl) {}
    public func visit(import: TSImportDecl) {}
    public func visit(interface: TSInterfaceDecl) {}
    public func visit(method: TSMethodDecl) {}
    public func visit(namespace: TSNamespaceDecl) {}
    public func visit(sourceFile: TSSourceFile) {}
    public func visit(type: TSTypeDecl) {}
    public func visit(`var`: TSVarDecl) {}

    public func visit(as: TSAsExpr) {}
    public func visit(call: TSCallExpr) {}
    public func visit(ident: TSIdentExpr) {}
    public func visit(infixOperator: TSInfixOperatorExpr) {}
    public func visit(new: TSNewExpr) {}
    public func visit(numberLiteral: TSNumberLiteralExpr) {}
    public func visit(paren: TSParenExpr) {}
    public func visit(prefixOperator: TSPrefixOperatorExpr) {}
    public func visit(stringLiteral: TSStringLiteralExpr) {}

    public func visit(block: TSBlockStmt) {}
    public func visit(forIn: TSForInStmt) {}
    public func visit(if: TSIfStmt) {}
    public func visit(return: TSReturnStmt) {}
    public func visit(throw: TSThrowStmt) {}

    public func visit(array: TSArrayType) {}
    public func visit(custom: TSCustomType) {}
    public func visit(dictionary: TSDictionaryType) {}
    public func visit(function: TSFunctionType) {}
    public func visit(ident: TSIdentType) {}
    public func visit(member: TSMemberType) {}
    public func visit(record: TSRecordType) {}
    public func visit(stringLiteral: TSStringLiteralType) {}
    public func visit(union: TSUnionType) {}
}
