extension TSSourceFile {
    public func scanDependency() -> [String] {
        let impl = Impl()
        impl.walk(self)
        return Array(impl.dependencies).sorted()
    }
}

private final class Impl: ASTVisitor {
    struct Context {
        var knownNames: Set<String> = []
    }

    var contextStack: [Context]
    var context: Context {
        get { contextStack.last! }
        set {
            contextStack[contextStack.count - 1] = newValue
        }
    }

    override init() {
        contextStack = [Context()]
        super.init()
    }

    func push() {
        contextStack.append(context)
    }
    func pop() {
        contextStack.removeLast()
    }

    var dependencies: Set<String> = []

    private func addNames(_ names: [String]) {
        context.knownNames.formUnion(names)
    }
    private func use(_ name: String) {
        if context.knownNames.contains(name) {
            return
        }

        dependencies.insert(name)
    }

    private func use(genericParams: [TSTypeParameterNode]) {
        addNames(genericParams.map(\.name))
        for genericParam in genericParams {
            if let constraint = genericParam.constraint {
                walk(constraint)
            }
            if let `default` = genericParam.default {
                walk(`default`)
            }
        }
    }

    override func visit(sourceFile: TSSourceFile) -> Bool {
        push()
        addNames(sourceFile.memberDeclaredNames)
        return true
    }

    override func visitPost(sourceFile: TSSourceFile) {
        pop()
    }

    override func visit(block: TSBlockStmt) -> Bool {
        push()
        addNames(block.memberDeclaredNames)
        return true
    }

    override func visitPost(block: TSBlockStmt) {
        pop()
    }

    override func visit(class: TSClassDecl) -> Bool {
        push()
        use(genericParams: `class`.genericParams)
        return true
    }

    override func visitPost(class: TSClassDecl) {
        pop()
    }

    override func visit(interface: TSInterfaceDecl) -> Bool {
        push()
        use(genericParams: interface.genericParams)
        return true
    }

    override func visitPost(interface: TSInterfaceDecl) {
        pop()
    }

    override func visit(function: TSFunctionDecl) -> Bool {
        push()
        use(genericParams: function.genericParams)
        addNames(function.params.map { $0.name })
        return true
    }

    override func visitPost(function: TSFunctionDecl) {
        pop()
    }

    override func visit(method: TSMethodDecl) -> Bool {
        push()
        use(genericParams: method.genericParams)
        addNames(method.params.map { $0.name })
        return true
    }

    override func visitPost(method: TSMethodDecl) {
        pop()
    }

    override func visit(type: TSTypeDecl) -> Bool {
        push()
        use(genericParams: type.genericParams)
        return true
    }

    override func visitPost(type: TSTypeDecl) {
        pop()
    }

    override func visit(case: TSCaseStmt) -> Bool {
        push()
        addNames(`case`.memberDeclaredNames)
        return true
    }

    override func visitPost(case: TSCaseStmt) {
        pop()
    }

    override func visit(catch: TSCatchStmt) -> Bool {
        push()
        if let name = `catch`.name {
            addNames([name])
        }
        return true
    }

    override func visitPost(catch: TSCatchStmt) {
        pop()
    }

    override func visit(default: TSDefaultStmt) -> Bool {
        push()
        addNames(`default`.memberDeclaredNames)
        return true
    }

    override func visitPost(default: TSDefaultStmt) {
        pop()
    }

    override func visit(forIn: TSForInStmt) -> Bool {
        push()
        addNames([forIn.name])
        return true
    }

    override func visitPost(forIn: TSForInStmt) {
        pop()
    }

    override func visit(closure: TSClosureExpr) -> Bool {
        push()
        use(genericParams: closure.genericParams)
        addNames(closure.params.map { $0.name })
        return true
    }

    override func visitPost(closure: TSClosureExpr) {
        pop()
    }

    override func visit(member: TSMemberExpr) -> Bool {
        walk(member.base)
        return false
    }

    override func visit(member: TSMemberType) -> Bool {
        walk(member.base)
        return false
    }

    override func visit(ident: TSIdentExpr) -> Bool {
        use(ident.name)
        return true
    }

    override func visit(custom: TSCustomExpr) -> Bool {
        for d in custom.dependencies {
            use(d)
        }
        return true
    }

    override func visit(conditional: TSConditionalType) -> Bool {
        walk(conditional.check)
        push()
        walk(conditional.extends)
        walk(conditional.true)
        pop()
        walk(conditional.false)
        return false
    }

    override func visit(custom: TSCustomType) -> Bool {
        for d in custom.dependencies {
            use(d)
        }
        return true
    }

    override func visit(function: TSFunctionType) -> Bool {
        push()
        use(genericParams: function.genericParams)
        return true
    }

    override func visit(ident: TSIdentType) -> Bool {
        use(ident.name)
        return true
    }

    override func visit(infer: TSInferType) -> Bool {
        addNames([infer.name])
        return true
    }

    override func visitPost(function: TSFunctionType) {
        pop()
    }

    override func visit(mapped: TSMappedType) -> Bool {
        push()
        addNames([mapped.name])
        return true
    }

    override func visitPost(mapped: TSMappedType) {
        pop()
    }
}
