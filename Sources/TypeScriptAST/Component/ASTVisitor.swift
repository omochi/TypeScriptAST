open class ASTVisitor {
    public init() {}

    public var defaultVisitResult: Bool { true }

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

    private func walk(_ param: TSFunctionType.Param) {
        walk(param.type)
    }

    private func walk(_ params: [TSFunctionType.Param]) {
        for param in params {
            walk(param)
        }
    }

    private func walk(_ field: TSObjectExpr.Field) {
        switch field {
        case .named(_, let value):
            walk(value)
        case .shorthandPropertyNames(let value):
            walk(value)
        case .computedPropertyNames(let name, let value):
            walk(name)
            walk(value)
        case .method(let decl):
            walk(decl)
        case .destructuring(let value):
            walk(value)
        }
    }

    private func walk(_ fields: [TSObjectExpr.Field]) {
        for field in fields {
            walk(field)
        }
    }

    private func walk(_ field: TSObjectType.Field) {
        switch field {
        case .field(let decl):
            walk(decl)
        case .method(let decl):
            walk(decl)
        case .index(let decl):
            walk(decl)
        }
    }

    private func walk(_ fields: [TSObjectType.Field]) {
        for field in fields {
            walk(field)
        }
    }

    // @codegen(visit)
    open func visit(`class`: TSClassDecl) -> Bool { defaultVisitResult }
    open func visitPost(`class`: TSClassDecl) {}
    open func visit(field: TSFieldDecl) -> Bool { defaultVisitResult }
    open func visitPost(field: TSFieldDecl) {}
    open func visit(function: TSFunctionDecl) -> Bool { defaultVisitResult }
    open func visitPost(function: TSFunctionDecl) {}
    open func visit(`import`: TSImportDecl) -> Bool { defaultVisitResult }
    open func visitPost(`import`: TSImportDecl) {}
    open func visit(index: TSIndexDecl) -> Bool { defaultVisitResult }
    open func visitPost(index: TSIndexDecl) {}
    open func visit(interface: TSInterfaceDecl) -> Bool { defaultVisitResult }
    open func visitPost(interface: TSInterfaceDecl) {}
    open func visit(method: TSMethodDecl) -> Bool { defaultVisitResult }
    open func visitPost(method: TSMethodDecl) {}
    open func visit(namespace: TSNamespaceDecl) -> Bool { defaultVisitResult }
    open func visitPost(namespace: TSNamespaceDecl) {}
    open func visit(sourceFile: TSSourceFile) -> Bool { defaultVisitResult }
    open func visitPost(sourceFile: TSSourceFile) {}
    open func visit(type: TSTypeDecl) -> Bool { defaultVisitResult }
    open func visitPost(type: TSTypeDecl) {}
    open func visit(`var`: TSVarDecl) -> Bool { defaultVisitResult }
    open func visitPost(`var`: TSVarDecl) {}
    open func visit(array: TSArrayExpr) -> Bool { defaultVisitResult }
    open func visitPost(array: TSArrayExpr) {}
    open func visit(`as`: TSAsExpr) -> Bool { defaultVisitResult }
    open func visitPost(`as`: TSAsExpr) {}
    open func visit(assign: TSAssignExpr) -> Bool { defaultVisitResult }
    open func visitPost(assign: TSAssignExpr) {}
    open func visit(`await`: TSAwaitExpr) -> Bool { defaultVisitResult }
    open func visitPost(`await`: TSAwaitExpr) {}
    open func visit(booleanLiteral: TSBooleanLiteralExpr) -> Bool { defaultVisitResult }
    open func visitPost(booleanLiteral: TSBooleanLiteralExpr) {}
    open func visit(call: TSCallExpr) -> Bool { defaultVisitResult }
    open func visitPost(call: TSCallExpr) {}
    open func visit(closure: TSClosureExpr) -> Bool { defaultVisitResult }
    open func visitPost(closure: TSClosureExpr) {}
    open func visit(custom: TSCustomExpr) -> Bool { defaultVisitResult }
    open func visitPost(custom: TSCustomExpr) {}
    open func visit(ident: TSIdentExpr) -> Bool { defaultVisitResult }
    open func visitPost(ident: TSIdentExpr) {}
    open func visit(infixOperator: TSInfixOperatorExpr) -> Bool { defaultVisitResult }
    open func visitPost(infixOperator: TSInfixOperatorExpr) {}
    open func visit(member: TSMemberExpr) -> Bool { defaultVisitResult }
    open func visitPost(member: TSMemberExpr) {}
    open func visit(new: TSNewExpr) -> Bool { defaultVisitResult }
    open func visitPost(new: TSNewExpr) {}
    open func visit(nullLiteral: TSNullLiteralExpr) -> Bool { defaultVisitResult }
    open func visitPost(nullLiteral: TSNullLiteralExpr) {}
    open func visit(numberLiteral: TSNumberLiteralExpr) -> Bool { defaultVisitResult }
    open func visitPost(numberLiteral: TSNumberLiteralExpr) {}
    open func visit(object: TSObjectExpr) -> Bool { defaultVisitResult }
    open func visitPost(object: TSObjectExpr) {}
    open func visit(paren: TSParenExpr) -> Bool { defaultVisitResult }
    open func visitPost(paren: TSParenExpr) {}
    open func visit(postfixOperator: TSPostfixOperatorExpr) -> Bool { defaultVisitResult }
    open func visitPost(postfixOperator: TSPostfixOperatorExpr) {}
    open func visit(prefixOperator: TSPrefixOperatorExpr) -> Bool { defaultVisitResult }
    open func visitPost(prefixOperator: TSPrefixOperatorExpr) {}
    open func visit(stringLiteral: TSStringLiteralExpr) -> Bool { defaultVisitResult }
    open func visitPost(stringLiteral: TSStringLiteralExpr) {}
    open func visit(`subscript`: TSSubscriptExpr) -> Bool { defaultVisitResult }
    open func visitPost(`subscript`: TSSubscriptExpr) {}
    open func visit(templateLiteral: TSTemplateLiteralExpr) -> Bool { defaultVisitResult }
    open func visitPost(templateLiteral: TSTemplateLiteralExpr) {}
    open func visit(block: TSBlockStmt) -> Bool { defaultVisitResult }
    open func visitPost(block: TSBlockStmt) {}
    open func visit(`case`: TSCaseStmt) -> Bool { defaultVisitResult }
    open func visitPost(`case`: TSCaseStmt) {}
    open func visit(`catch`: TSCatchStmt) -> Bool { defaultVisitResult }
    open func visitPost(`catch`: TSCatchStmt) {}
    open func visit(`default`: TSDefaultStmt) -> Bool { defaultVisitResult }
    open func visitPost(`default`: TSDefaultStmt) {}
    open func visit(finally: TSFinallyStmt) -> Bool { defaultVisitResult }
    open func visitPost(finally: TSFinallyStmt) {}
    open func visit(forIn: TSForInStmt) -> Bool { defaultVisitResult }
    open func visitPost(forIn: TSForInStmt) {}
    open func visit(`if`: TSIfStmt) -> Bool { defaultVisitResult }
    open func visitPost(`if`: TSIfStmt) {}
    open func visit(`return`: TSReturnStmt) -> Bool { defaultVisitResult }
    open func visitPost(`return`: TSReturnStmt) {}
    open func visit(`switch`: TSSwitchStmt) -> Bool { defaultVisitResult }
    open func visitPost(`switch`: TSSwitchStmt) {}
    open func visit(`throw`: TSThrowStmt) -> Bool { defaultVisitResult }
    open func visitPost(`throw`: TSThrowStmt) {}
    open func visit(`try`: TSTryStmt) -> Bool { defaultVisitResult }
    open func visitPost(`try`: TSTryStmt) {}
    open func visit(array: TSArrayType) -> Bool { defaultVisitResult }
    open func visitPost(array: TSArrayType) {}
    open func visit(conditional: TSConditionalType) -> Bool { defaultVisitResult }
    open func visitPost(conditional: TSConditionalType) {}
    open func visit(custom: TSCustomType) -> Bool { defaultVisitResult }
    open func visitPost(custom: TSCustomType) {}
    open func visit(function: TSFunctionType) -> Bool { defaultVisitResult }
    open func visitPost(function: TSFunctionType) {}
    open func visit(ident: TSIdentType) -> Bool { defaultVisitResult }
    open func visitPost(ident: TSIdentType) {}
    open func visit(indexedAccess: TSIndexedAccessType) -> Bool { defaultVisitResult }
    open func visitPost(indexedAccess: TSIndexedAccessType) {}
    open func visit(infer: TSInferType) -> Bool { defaultVisitResult }
    open func visitPost(infer: TSInferType) {}
    open func visit(intersection: TSIntersectionType) -> Bool { defaultVisitResult }
    open func visitPost(intersection: TSIntersectionType) {}
    open func visit(member: TSMemberType) -> Bool { defaultVisitResult }
    open func visitPost(member: TSMemberType) {}
    open func visit(numberLiteral: TSNumberLiteralType) -> Bool { defaultVisitResult }
    open func visitPost(numberLiteral: TSNumberLiteralType) {}
    open func visit(object: TSObjectType) -> Bool { defaultVisitResult }
    open func visitPost(object: TSObjectType) {}
    open func visit(stringLiteral: TSStringLiteralType) -> Bool { defaultVisitResult }
    open func visitPost(stringLiteral: TSStringLiteralType) {}
    open func visit(union: TSUnionType) -> Bool { defaultVisitResult }
    open func visitPost(union: TSUnionType) {}
    // @end

    // @codegen(dispatch)
    private func dispatch(_ node: any ASTNode) {
        switch node {
        case let x as TSClassDecl: visitImpl(class: x)
        case let x as TSFieldDecl: visitImpl(field: x)
        case let x as TSFunctionDecl: visitImpl(function: x)
        case let x as TSImportDecl: visitImpl(import: x)
        case let x as TSIndexDecl: visitImpl(index: x)
        case let x as TSInterfaceDecl: visitImpl(interface: x)
        case let x as TSMethodDecl: visitImpl(method: x)
        case let x as TSNamespaceDecl: visitImpl(namespace: x)
        case let x as TSSourceFile: visitImpl(sourceFile: x)
        case let x as TSTypeDecl: visitImpl(type: x)
        case let x as TSVarDecl: visitImpl(var: x)
        case let x as TSArrayExpr: visitImpl(array: x)
        case let x as TSAsExpr: visitImpl(as: x)
        case let x as TSAssignExpr: visitImpl(assign: x)
        case let x as TSAwaitExpr: visitImpl(await: x)
        case let x as TSBooleanLiteralExpr: visitImpl(booleanLiteral: x)
        case let x as TSCallExpr: visitImpl(call: x)
        case let x as TSClosureExpr: visitImpl(closure: x)
        case let x as TSCustomExpr: visitImpl(custom: x)
        case let x as TSIdentExpr: visitImpl(ident: x)
        case let x as TSInfixOperatorExpr: visitImpl(infixOperator: x)
        case let x as TSMemberExpr: visitImpl(member: x)
        case let x as TSNewExpr: visitImpl(new: x)
        case let x as TSNullLiteralExpr: visitImpl(nullLiteral: x)
        case let x as TSNumberLiteralExpr: visitImpl(numberLiteral: x)
        case let x as TSObjectExpr: visitImpl(object: x)
        case let x as TSParenExpr: visitImpl(paren: x)
        case let x as TSPostfixOperatorExpr: visitImpl(postfixOperator: x)
        case let x as TSPrefixOperatorExpr: visitImpl(prefixOperator: x)
        case let x as TSStringLiteralExpr: visitImpl(stringLiteral: x)
        case let x as TSSubscriptExpr: visitImpl(subscript: x)
        case let x as TSTemplateLiteralExpr: visitImpl(templateLiteral: x)
        case let x as TSBlockStmt: visitImpl(block: x)
        case let x as TSCaseStmt: visitImpl(case: x)
        case let x as TSCatchStmt: visitImpl(catch: x)
        case let x as TSDefaultStmt: visitImpl(default: x)
        case let x as TSFinallyStmt: visitImpl(finally: x)
        case let x as TSForInStmt: visitImpl(forIn: x)
        case let x as TSIfStmt: visitImpl(if: x)
        case let x as TSReturnStmt: visitImpl(return: x)
        case let x as TSSwitchStmt: visitImpl(switch: x)
        case let x as TSThrowStmt: visitImpl(throw: x)
        case let x as TSTryStmt: visitImpl(try: x)
        case let x as TSArrayType: visitImpl(array: x)
        case let x as TSConditionalType: visitImpl(conditional: x)
        case let x as TSCustomType: visitImpl(custom: x)
        case let x as TSFunctionType: visitImpl(function: x)
        case let x as TSIdentType: visitImpl(ident: x)
        case let x as TSIndexedAccessType: visitImpl(indexedAccess: x)
        case let x as TSInferType: visitImpl(infer: x)
        case let x as TSIntersectionType: visitImpl(intersection: x)
        case let x as TSMemberType: visitImpl(member: x)
        case let x as TSNumberLiteralType: visitImpl(numberLiteral: x)
        case let x as TSObjectType: visitImpl(object: x)
        case let x as TSStringLiteralType: visitImpl(stringLiteral: x)
        case let x as TSUnionType: visitImpl(union: x)
        default: break
        }
    }
    // @end

    // @codegen(visitImpl)
    private func visitImpl(`class`: TSClassDecl) {
        guard visit(class: `class`) else { return }
        walk(`class`.extends)
        walk(`class`.implements)
        walk(`class`.body)
        visitPost(class: `class`)
    }

    private func visitImpl(field: TSFieldDecl) {
        guard visit(field: field) else { return }
        walk(field.type)
        visitPost(field: field)
    }

    private func visitImpl(function: TSFunctionDecl) {
        guard visit(function: function) else { return }
        walk(function.params)
        walk(function.result)
        walk(function.body)
        visitPost(function: function)
    }

    private func visitImpl(`import`: TSImportDecl) {
        guard visit(import: `import`) else { return }
        visitPost(import: `import`)
    }

    private func visitImpl(index: TSIndexDecl) {
        guard visit(index: index) else { return }
        walk(index.type)
        visitPost(index: index)
    }

    private func visitImpl(interface: TSInterfaceDecl) {
        guard visit(interface: interface) else { return }
        walk(interface.extends)
        walk(interface.body)
        visitPost(interface: interface)
    }

    private func visitImpl(method: TSMethodDecl) {
        guard visit(method: method) else { return }
        walk(method.params)
        walk(method.result)
        walk(method.body)
        visitPost(method: method)
    }

    private func visitImpl(namespace: TSNamespaceDecl) {
        guard visit(namespace: namespace) else { return }
        walk(namespace.body)
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

    private func visitImpl(`as`: TSAsExpr) {
        guard visit(as: `as`) else { return }
        walk(`as`.expr)
        walk(`as`.type)
        visitPost(as: `as`)
    }

    private func visitImpl(assign: TSAssignExpr) {
        guard visit(assign: assign) else { return }
        walk(assign.lhs)
        walk(assign.rhs)
        visitPost(assign: assign)
    }

    private func visitImpl(`await`: TSAwaitExpr) {
        guard visit(await: `await`) else { return }
        walk(`await`.expr)
        visitPost(await: `await`)
    }

    private func visitImpl(booleanLiteral: TSBooleanLiteralExpr) {
        guard visit(booleanLiteral: booleanLiteral) else { return }
        visitPost(booleanLiteral: booleanLiteral)
    }

    private func visitImpl(call: TSCallExpr) {
        guard visit(call: call) else { return }
        walk(call.callee)
        walk(call.args)
        visitPost(call: call)
    }

    private func visitImpl(closure: TSClosureExpr) {
        guard visit(closure: closure) else { return }
        walk(closure.params)
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

    private func visitImpl(member: TSMemberExpr) {
        guard visit(member: member) else { return }
        walk(member.base)
        visitPost(member: member)
    }

    private func visitImpl(new: TSNewExpr) {
        guard visit(new: new) else { return }
        walk(new.callee)
        walk(new.args)
        visitPost(new: new)
    }

    private func visitImpl(nullLiteral: TSNullLiteralExpr) {
        guard visit(nullLiteral: nullLiteral) else { return }
        visitPost(nullLiteral: nullLiteral)
    }

    private func visitImpl(numberLiteral: TSNumberLiteralExpr) {
        guard visit(numberLiteral: numberLiteral) else { return }
        visitPost(numberLiteral: numberLiteral)
    }

    private func visitImpl(object: TSObjectExpr) {
        guard visit(object: object) else { return }
        walk(object.fields)
        visitPost(object: object)
    }

    private func visitImpl(paren: TSParenExpr) {
        guard visit(paren: paren) else { return }
        walk(paren.expr)
        visitPost(paren: paren)
    }

    private func visitImpl(postfixOperator: TSPostfixOperatorExpr) {
        guard visit(postfixOperator: postfixOperator) else { return }
        walk(postfixOperator.expr)
        visitPost(postfixOperator: postfixOperator)
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

    private func visitImpl(`subscript`: TSSubscriptExpr) {
        guard visit(subscript: `subscript`) else { return }
        visitPost(subscript: `subscript`)
    }

    private func visitImpl(templateLiteral: TSTemplateLiteralExpr) {
        guard visit(templateLiteral: templateLiteral) else { return }
        walk(templateLiteral.substitutions)
        visitPost(templateLiteral: templateLiteral)
    }

    private func visitImpl(block: TSBlockStmt) {
        guard visit(block: block) else { return }
        walk(block.elements)
        visitPost(block: block)
    }

    private func visitImpl(`case`: TSCaseStmt) {
        guard visit(case: `case`) else { return }
        walk(`case`.expr)
        walk(`case`.elements)
        visitPost(case: `case`)
    }

    private func visitImpl(`catch`: TSCatchStmt) {
        guard visit(catch: `catch`) else { return }
        walk(`catch`.body)
        visitPost(catch: `catch`)
    }

    private func visitImpl(`default`: TSDefaultStmt) {
        guard visit(default: `default`) else { return }
        walk(`default`.elements)
        visitPost(default: `default`)
    }

    private func visitImpl(finally: TSFinallyStmt) {
        guard visit(finally: finally) else { return }
        walk(finally.body)
        visitPost(finally: finally)
    }

    private func visitImpl(forIn: TSForInStmt) {
        guard visit(forIn: forIn) else { return }
        walk(forIn.expr)
        walk(forIn.body)
        visitPost(forIn: forIn)
    }

    private func visitImpl(`if`: TSIfStmt) {
        guard visit(if: `if`) else { return }
        walk(`if`.condition)
        walk(`if`.then)
        walk(`if`.else)
        visitPost(if: `if`)
    }

    private func visitImpl(`return`: TSReturnStmt) {
        guard visit(return: `return`) else { return }
        walk(`return`.expr)
        visitPost(return: `return`)
    }

    private func visitImpl(`switch`: TSSwitchStmt) {
        guard visit(switch: `switch`) else { return }
        walk(`switch`.expr)
        walk(`switch`.cases)
        visitPost(switch: `switch`)
    }

    private func visitImpl(`throw`: TSThrowStmt) {
        guard visit(throw: `throw`) else { return }
        walk(`throw`.expr)
        visitPost(throw: `throw`)
    }

    private func visitImpl(`try`: TSTryStmt) {
        guard visit(try: `try`) else { return }
        walk(`try`.body)
        visitPost(try: `try`)
    }

    private func visitImpl(array: TSArrayType) {
        guard visit(array: array) else { return }
        walk(array.element)
        visitPost(array: array)
    }

    private func visitImpl(conditional: TSConditionalType) {
        guard visit(conditional: conditional) else { return }
        walk(conditional.check)
        walk(conditional.extends)
        walk(conditional.true)
        walk(conditional.false)
        visitPost(conditional: conditional)
    }

    private func visitImpl(custom: TSCustomType) {
        guard visit(custom: custom) else { return }
        visitPost(custom: custom)
    }

    private func visitImpl(function: TSFunctionType) {
        guard visit(function: function) else { return }
        walk(function.params)
        walk(function.result)
        visitPost(function: function)
    }

    private func visitImpl(ident: TSIdentType) {
        guard visit(ident: ident) else { return }
        walk(ident.genericArgs)
        visitPost(ident: ident)
    }

    private func visitImpl(indexedAccess: TSIndexedAccessType) {
        guard visit(indexedAccess: indexedAccess) else { return }
        walk(indexedAccess.base)
        walk(indexedAccess.index)
        visitPost(indexedAccess: indexedAccess)
    }

    private func visitImpl(infer: TSInferType) {
        guard visit(infer: infer) else { return }
        visitPost(infer: infer)
    }

    private func visitImpl(intersection: TSIntersectionType) {
        guard visit(intersection: intersection) else { return }
        walk(intersection.elements)
        visitPost(intersection: intersection)
    }

    private func visitImpl(member: TSMemberType) {
        guard visit(member: member) else { return }
        walk(member.base)
        walk(member.genericArgs)
        visitPost(member: member)
    }

    private func visitImpl(numberLiteral: TSNumberLiteralType) {
        guard visit(numberLiteral: numberLiteral) else { return }
        visitPost(numberLiteral: numberLiteral)
    }

    private func visitImpl(object: TSObjectType) {
        guard visit(object: object) else { return }
        walk(object.fields)
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
    // @end
}
