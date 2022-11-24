open class ASTVisitor {
    public init() {}

    public func walk(_ node: any ASTNode) {
        dispatch(node)
    }

    private func walk(_ node: (any ASTNode)?) {
        if let node {
            walk(node)
        }
    }

    private func walk(_ nodes: [any ASTNode]) {
        for node in nodes {
            walk(node)
        }
    }

    private func walk(param: TSFunctionType.Param) {
        walk(param.type)
    }

    private func walk(params: [TSFunctionType.Param]) {
        for param in params {
            walk(param: param)
        }
    }

    private func walk(field: TSObjectExpr.Field) {
        walk(field.value)
    }

    private func walk(fields: [TSObjectExpr.Field]) {
        for field in fields {
            walk(field: field)
        }
    }

    private func walk(field: TSObjectType.Field) {
        walk(field.type)
    }

    private func walk(fields: [TSObjectType.Field]) {
        for field in fields {
            walk(field: field)
        }
    }

    open func visit(class: TSClassDecl) -> Bool { true }
    open func visitPost(class: TSClassDecl) {}
    open func visit(field: TSFieldDecl) -> Bool { true }
    open func visitPost(field: TSFieldDecl) {}
    open func visit(function: TSFunctionDecl) -> Bool { true }
    open func visitPost(function: TSFunctionDecl) {}
    open func visit(import: TSImportDecl) -> Bool { true }
    open func visitPost(import: TSImportDecl) {}
    open func visit(interface: TSInterfaceDecl) -> Bool { true }
    open func visitPost(interface: TSInterfaceDecl) {}
    open func visit(method: TSMethodDecl) -> Bool { true }
    open func visitPost(method: TSMethodDecl) {}
    open func visit(namespace: TSNamespaceDecl) -> Bool { true }
    open func visitPost(namespace: TSNamespaceDecl) {}
    open func visit(sourceFile: TSSourceFile) -> Bool { true }
    open func visitPost(sourceFile: TSSourceFile) {}
    open func visit(type: TSTypeDecl) -> Bool { true }
    open func visitPost(type: TSTypeDecl) {}
    open func visit(`var`: TSVarDecl) -> Bool { true }
    open func visitPost(`var`: TSVarDecl) {}

    open func visit(array: TSArrayExpr) -> Bool { true }
    open func visitPost(array: TSArrayExpr) {}
    open func visit(as: TSAsExpr) -> Bool { true }
    open func visitPost(as: TSAsExpr) {}
    open func visit(await: TSAwaitExpr) -> Bool { true }
    open func visitPost(await: TSAwaitExpr) {}
    open func visit(call: TSCallExpr) -> Bool { true }
    open func visitPost(call: TSCallExpr) {}
    open func visit(closure: TSClosureExpr) -> Bool { true }
    open func visitPost(closure: TSClosureExpr) {}
    open func visit(custom: TSCustomExpr) -> Bool { true }
    open func visitPost(custom: TSCustomExpr) {}
    open func visit(ident: TSIdentExpr) -> Bool { true }
    open func visitPost(ident: TSIdentExpr) {}
    open func visit(infixOperator: TSInfixOperatorExpr) -> Bool { true }
    open func visitPost(infixOperator: TSInfixOperatorExpr) {}
    open func visit(new: TSNewExpr) -> Bool { true }
    open func visitPost(new: TSNewExpr) {}
    open func visit(numberLiteral: TSNumberLiteralExpr) -> Bool { true }
    open func visitPost(numberLiteral: TSNumberLiteralExpr) {}
    open func visit(object: TSObjectExpr) -> Bool { true }
    open func visitPost(object: TSObjectExpr) {}
    open func visit(paren: TSParenExpr) -> Bool { true }
    open func visitPost(paren: TSParenExpr) {}
    open func visit(prefixOperator: TSPrefixOperatorExpr) -> Bool { true }
    open func visitPost(prefixOperator: TSPrefixOperatorExpr) {}
    open func visit(stringLiteral: TSStringLiteralExpr) -> Bool { true }
    open func visitPost(stringLiteral: TSStringLiteralExpr) {}

    open func visit(block: TSBlockStmt) -> Bool { true }
    open func visitPost(block: TSBlockStmt) {}
    open func visit(forIn: TSForInStmt) -> Bool { true }
    open func visitPost(forIn: TSForInStmt) {}
    open func visit(if: TSIfStmt) -> Bool { true }
    open func visitPost(if: TSIfStmt) {}
    open func visit(return: TSReturnStmt) -> Bool { true }
    open func visitPost(return: TSReturnStmt) {}
    open func visit(throw: TSThrowStmt) -> Bool { true }
    open func visitPost(throw: TSThrowStmt) {}

    open func visit(array: TSArrayType) -> Bool { true }
    open func visitPost(array: TSArrayType) {}
    open func visit(custom: TSCustomType) -> Bool { true }
    open func visitPost(custom: TSCustomType) {}
    open func visit(dictionary: TSDictionaryType) -> Bool { true }
    open func visitPost(dictionary: TSDictionaryType) {}
    open func visit(function: TSFunctionType) -> Bool { true }
    open func visitPost(function: TSFunctionType) {}
    open func visit(ident: TSIdentType) -> Bool { true }
    open func visitPost(ident: TSIdentType) {}
    open func visit(member: TSMemberType) -> Bool { true }
    open func visitPost(member: TSMemberType) {}
    open func visit(object: TSObjectType) -> Bool { true }
    open func visitPost(object: TSObjectType) {}
    open func visit(stringLiteral: TSStringLiteralType) -> Bool { true }
    open func visitPost(stringLiteral: TSStringLiteralType) {}
    open func visit(union: TSUnionType) -> Bool { true }
    open func visitPost(union: TSUnionType) {}

    private func dispatch(_ node: any ASTNode) {
        switch node {
        case let x as TSClassDecl: visitImpl(class: x)
        case let x as TSFieldDecl: visitImpl(field: x)
        case let x as TSFunctionDecl: visitImpl(function: x)
        case let x as TSImportDecl: visitImpl(import: x)
        case let x as TSInterfaceDecl: visitImpl(interface: x)
        case let x as TSMethodDecl: visitImpl(method: x)
        case let x as TSNamespaceDecl: visitImpl(namespace: x)
        case let x as TSSourceFile: visitImpl(sourceFile: x)
        case let x as TSTypeDecl: visitImpl(type: x)
        case let x as TSVarDecl: visitImpl(var: x)
        case let x as TSArrayExpr: visitImpl(array: x)
        case let x as TSAsExpr: visitImpl(as: x)
        case let x as TSAwaitExpr: visitImpl(await: x)
        case let x as TSCallExpr: visitImpl(call: x)
        case let x as TSClosureExpr: visitImpl(closure: x)
        case let x as TSCustomExpr: visitImpl(custom: x)
        case let x as TSIdentExpr: visitImpl(ident: x)
        case let x as TSInfixOperatorExpr: visitImpl(infixOperator: x)
        case let x as TSNewExpr: visitImpl(new: x)
        case let x as TSNumberLiteralExpr: visitImpl(numberLiteral: x)
        case let x as TSObjectExpr: visitImpl(object: x)
        case let x as TSParenExpr: visitImpl(paren: x)
        case let x as TSPrefixOperatorExpr: visitImpl(prefixOperator: x)
        case let x as TSStringLiteralExpr: visitImpl(stringLiteral: x)
        case let x as TSBlockStmt: visitImpl(block: x)
        case let x as TSForInStmt: visitImpl(forIn: x)
        case let x as TSIfStmt: visitImpl(if: x)
        case let x as TSReturnStmt: visitImpl(return: x)
        case let x as TSThrowStmt: visitImpl(throw: x)
        case let x as TSArrayType: visitImpl(array: x)
        case let x as TSCustomType: visitImpl(custom: x)
        case let x as TSDictionaryType: visitImpl(dictionary: x)
        case let x as TSFunctionType: visitImpl(function: x)
        case let x as TSIdentType: visitImpl(ident: x)
        case let x as TSMemberType: visitImpl(member: x)
        case let x as TSObjectType: visitImpl(object: x)
        case let x as TSStringLiteralType: visitImpl(stringLiteral: x)
        case let x as TSUnionType: visitImpl(union: x)
        default: break
        }
    }

    private func visitImpl(class: TSClassDecl) {
        guard visit(class: `class`) else { return }
        walk(`class`.extends)
        walk(`class`.implements)
        walk(`class`.block)
        visitPost(class: `class`)
    }

    private func visitImpl(field: TSFieldDecl) {
        guard visit(field: field) else { return }
        walk(field.type)
        visitPost(field: field)
    }

    private func visitImpl(function: TSFunctionDecl) {
        guard visit(function: function) else { return }
        walk(params: function.params)
        walk(function.result)
        walk(function.body)
        visitPost(function: function)
    }

    private func visitImpl(import: TSImportDecl) {
        guard visit(import: `import`) else { return }
        visitPost(import: `import`)
    }

    private func visitImpl(interface: TSInterfaceDecl) {
        guard visit(interface: interface) else { return }
        walk(interface.extends)
        walk(interface.block)
        visitPost(interface: interface)
    }

    private func visitImpl(method: TSMethodDecl) {
        guard visit(method: method) else { return }
        walk(params: method.params)
        walk(method.result)
        walk(method.block)
        visitPost(method: method)
    }

    private func visitImpl(namespace: TSNamespaceDecl) {
        guard visit(namespace: namespace) else { return }
        walk(namespace.block)
        visitPost(namespace: namespace)
    }

    private func visitImpl(sourceFile: TSSourceFile) {
        guard visit(sourceFile: sourceFile) else { return }
        walk(sourceFile.elements)
        visitPost(sourceFile: sourceFile)
    }

    private func visitImpl(type: TSTypeDecl) {
        guard visit(type: type) else { return }
        walk(type.type)
        visitPost(type: type)
    }

    private func visitImpl(`var`: TSVarDecl) {
        guard visit(var: `var`) else { return }
        walk(`var`.type)
        walk(`var`.initializer)
        visitPost(var: `var`)
    }

    private func visitImpl(array: TSArrayExpr) {
        guard visit(array: array) else { return }
        walk(array.elements)
        visitPost(array: array)
    }

    private func visitImpl(as: TSAsExpr) {
        guard visit(as: `as`) else { return }
        walk(`as`.expr)
        walk(`as`.type)
        visitPost(as: `as`)
    }

    private func visitImpl(await: TSAwaitExpr) {
        guard visit(await: `await`) else { return }
        walk(`await`.expr)
        visitPost(await: `await`)
    }

    private func visitImpl(call: TSCallExpr) {
        guard visit(call: call) else { return }
        walk(call.callee)
        walk(call.args)
        visitPost(call: call)
    }

    private func visitImpl(closure: TSClosureExpr) {
        guard visit(closure: closure) else { return }
        walk(params: closure.params)
        walk(closure.result)
        walk(closure.body)
        visitPost(closure: closure)
    }

    private func visitImpl(custom: TSCustomExpr) {
        guard visit(custom: custom) else { return }
        visitPost(custom: custom)
    }

    private func visitImpl(ident: TSIdentExpr) {
        guard visit(ident: ident) else { return }
        visitPost(ident: ident)
    }

    private func visitImpl(infixOperator: TSInfixOperatorExpr) {
        guard visit(infixOperator: infixOperator) else { return }
        walk(infixOperator.lhs)
        walk(infixOperator.rhs)
        visitPost(infixOperator: infixOperator)
    }

    private func visitImpl(new: TSNewExpr) {
        guard visit(new: new) else { return }
        walk(new.callee)
        walk(new.args)
        visitPost(new: new)
    }

    private func visitImpl(numberLiteral: TSNumberLiteralExpr) {
        guard visit(numberLiteral: numberLiteral) else { return }
        visitPost(numberLiteral: numberLiteral)
    }

    private func visitImpl(object: TSObjectExpr) {
        guard visit(object: object) else { return }
        walk(fields: object.fields)
        visitPost(object: object)
    }

    private func visitImpl(paren: TSParenExpr) {
        guard visit(paren: paren) else { return }
        walk(paren.expr)
        visitPost(paren: paren)
    }

    private func visitImpl(prefixOperator: TSPrefixOperatorExpr) {
        guard visit(prefixOperator: prefixOperator) else { return }
        walk(prefixOperator.expr)
        visitPost(prefixOperator: prefixOperator)
    }

    private func visitImpl(stringLiteral: TSStringLiteralExpr) {
        guard visit(stringLiteral: stringLiteral) else { return }
        visitPost(stringLiteral: stringLiteral)
    }

    private func visitImpl(block: TSBlockStmt) {
        guard visit(block: block) else { return }
        walk(block.elements)
        visitPost(block: block)
    }

    private func visitImpl(forIn: TSForInStmt) {
        guard visit(forIn: forIn) else { return }
        walk(forIn.expr)
        walk(forIn.body)
        visitPost(forIn: forIn)
    }

    private func visitImpl(if: TSIfStmt) {
        guard visit(if: `if`) else { return }
        walk(`if`.condition)
        walk(`if`.then)
        walk(`if`.else)
        visitPost(if: `if`)
    }

    private func visitImpl(return: TSReturnStmt) {
        guard visit(return: `return`) else { return }
        walk(`return`.expr)
        visitPost(return: `return`)
    }

    private func visitImpl(throw: TSThrowStmt) {
        guard visit(throw: `throw`) else { return }
        walk(`throw`.expr)
        visitPost(throw: `throw`)
    }

    private func visitImpl(array: TSArrayType) {
        guard visit(array: array) else { return }
        walk(array.element)
        visitPost(array: array)
    }

    private func visitImpl(custom: TSCustomType) {
        guard visit(custom: custom) else { return }
        visitPost(custom: custom)
    }

    private func visitImpl(dictionary: TSDictionaryType) {
        guard visit(dictionary: dictionary) else { return }
        walk(dictionary.value)
        visitPost(dictionary: dictionary)
    }

    private func visitImpl(function: TSFunctionType) {
        guard visit(function: function) else { return }
        walk(params: function.params)
        walk(function.result)
        visitPost(function: function)
    }

    private func visitImpl(ident: TSIdentType) {
        guard visit(ident: ident) else { return }
        walk(ident.genericArgs)
        visitPost(ident: ident)
    }

    private func visitImpl(member: TSMemberType) {
        guard visit(member: member) else { return }
        walk(member.base)
        walk(member.name)
        visitPost(member: member)
    }

    private func visitImpl(object: TSObjectType) {
        guard visit(object: object) else { return }
        walk(fields: object.fields)
        visitPost(object: object)
    }

    private func visitImpl(stringLiteral: TSStringLiteralType) {
        guard visit(stringLiteral: stringLiteral) else { return }
        visitPost(stringLiteral: stringLiteral)
    }

    private func visitImpl(union: TSUnionType) {
        guard visit(union: union) else { return }
        walk(union.elements)
        visitPost(union: union)
    }
}
