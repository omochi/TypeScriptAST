public final class ASTPrinter: ASTVisitor {
    public enum ScopeKind {
        case topLevel
        case namespace
        case `class`
        case function
        case interface
    }

    public enum MultilineMode {
        case oneline
        case multiline
        case automatic
    }

    private struct Context {
        var scope: ScopeKind
        var isInBrackets: Bool
    }

    public init(scope: ScopeKind = .topLevel) {
        self.contextStack = [
            Context(
                scope: scope,
                isInBrackets: false
            )
        ]
    }

    private var printer: PrettyPrinter!
    public var onelineCount: Int = 3

    private var contextStack: [Context]
    private var context: Context {
        get { contextStack.last! }
        set {
            contextStack[contextStack.count - 1] = newValue
        }
    }
    private func pushContext() {
        contextStack.append(context)
    }
    private func popContext() {
        contextStack.removeLast()
    }

    public func print(_ node: any ASTNode) -> String {
        printer = PrettyPrinter()
        visit(node)
        return printer.output
    }

    private func openBracket(
        scope: ScopeKind? = nil,
        space: String? = nil,
        _ text: String
    ) {
        pushContext()
        printer.write(space: space, text)
        context.isInBrackets = true
        if let scope {
            context.scope = scope
        }
    }

    private func closeBracket(_ text: String) {
        printer.write(text)
        context.isInBrackets = false
        popContext()
    }

    private func printsNewline(
        after prev: any ASTNode,
        before node: any ASTNode
    ) -> Bool {
        guard let prev = prev.asDecl,
              let decl = node.asDecl else
        {
            return false
        }

        if type(of: prev) != type(of: decl) {
            return true
        }

        switch decl {
        case is TSClassDecl:
            return true
        case is TSFieldDecl:
            return false
        case is TSImportDecl:
            return false
        case is TSInterfaceDecl:
            return true
        case is TSFunctionDecl,
            is TSMethodDecl:
            switch context.scope {
            case .interface:
                return false
            default:
                return true
            }
        case is TSNamespaceDecl:
            return true
        case is TSSourceFile:
            return true
        case is TSTypeDecl:
            return true
        case is TSVarDecl:
            switch context.scope {
            case .topLevel, .namespace:
                return true
            default:
                return false
            }
        default:
            return true
        }
    }

    private func write<T>(
        array: [T],
        sideSpace: Bool = false,
        separator: String = "",
        multilineMode: MultilineMode = .automatic,
        writeElement: (T) -> Void
    ) {
        if array.isEmpty { return }

        let isMultiline: Bool = {
            switch multilineMode {
            case .automatic:
                return array.count > onelineCount
            case .oneline: return false
            case .multiline: return true
            }
        }()

        if isMultiline, context.isInBrackets {
            printer.push()
        }

        for (index, element) in array.enumerated() {
            if sideSpace, index == 0, !isMultiline {
                printer.write(space: " ")
            }
            if index > 0 {
                printer.write(space: " ")
            }

            writeElement(element)

            if index < array.count - 1 {
                printer.write(separator)
                if isMultiline {
                    printer.writeNewline()
                }
            } else {
                if sideSpace, !isMultiline {
                    printer.write(space: " ")
                }
            }
        }

        if isMultiline, context.isInBrackets {
            printer.pop()
        }
    }

    private func write(blockElements elements: [any ASTNode]) {
        if elements.isEmpty { return }
        if context.isInBrackets {
            printer.push()
        }

        for (index, element) in elements.enumerated() {
            if index > 0 {
                if printsNewline(after: elements[index - 1], before: element) {
                    printer.writeNewline()
                }
            }

            visit(element)

            if index < elements.count - 1 {
                printer.writeNewline()
            }
        }

        if context.isInBrackets {
            printer.pop()
        }
    }

    private func write(modifiers: [TSDeclModifier]) {
        write(array: modifiers, multilineMode: .oneline) {
            printer.write($0.rawValue)
        }
    }

    private func write(genericArgs: [any TSType]) {
        if genericArgs.isEmpty { return }
        openBracket("<")
        write(array: genericArgs, separator: ",") {
            visit($0)
        }
        closeBracket(">")
    }

    private func write(genericParams: [String]) {
        if genericParams.isEmpty { return }
        openBracket("<")
        write(array: genericParams, separator: ",") {
            printer.write($0)
        }
        closeBracket(">")
    }

    public func visit(class: TSClassDecl) {
        write(modifiers: `class`.modifiers)
        printer.write(space: " ", "class \(`class`.name)")
        write(genericParams: `class`.genericParams)
        if let extends = `class`.extends {
            printer.write(" extends ")
            visit(extends)
        }
        if !`class`.implements.isEmpty {
            printer.write(" implements ")
            write(array: `class`.implements, separator: ",") {
                visit($0)
            }
        }
        printer.write(space: " ")
        write(block: `class`.block, scope: .class)
    }

    public func visit(field: TSFieldDecl) {
        write(modifiers: field.modifiers)
        printer.write(space: " ", field.name)
        if field.isOptional {
            printer.write("?: ")
        } else {
            printer.write(": ")
        }
        visit(field.type)
        printer.write(";")
    }

    public func visit(function: TSFunctionDecl) {
        write(modifiers: function.modifiers)
        printer.write(space: " ", "function \(function.name)")
        write(genericParams: function.genericParams)
        write(params: function.params)
        if let result = function.result {
            printer.write(": ")
            visit(result)
        }
        printer.write(space: " ")
        write(block: function.body, scope: .function)
    }

    private func write(params: [TSFunctionDecl.Param]) {
        openBracket("(")
        write(array: params, separator: ",") {
            write(param: $0)
        }
        closeBracket(")")
    }

    private func write(param: TSFunctionDecl.Param) {
        printer.write(param.name)
        if let type = param.type {
            printer.write(": ")
            visit(type)
        }
    }

    public func visit(interface: TSInterfaceDecl) {
        write(modifiers: interface.modifiers)
        printer.write(space: " ", "interface \(interface.name)")
        write(genericParams: interface.genericParams)
        if !interface.extends.isEmpty {
            printer.write(" extends ")
            write(array: interface.extends, separator: ",") {
                visit($0)
            }
        }
        printer.write(space: " ")
        write(block: interface.block, scope: .interface)
    }

    public func visit(import: TSImportDecl) {
        printer.write("import ")
        openBracket("{")
        write(array: `import`.names, sideSpace: true, separator: ",") {
            printer.write($0)
        }
        closeBracket("}")
        printer.write(" from \"\(`import`.from)\";")
    }

    public func visit(method: TSMethodDecl) {
        write(modifiers: method.modifiers)
        printer.write(space: " ", method.name)
        write(genericParams: method.genericParams)
        write(params: method.params)
        if let result = method.result {
            printer.write(": ")
            visit(result)
        }
        if let block = method.block {
            printer.write(space: " ")
            write(block: block)
        } else {
            printer.write(";")
        }
    }

    public func visit(namespace: TSNamespaceDecl) {
        write(modifiers: namespace.modifiers)
        printer.write(space: " ", "namespace \(namespace.name) ")
        write(block: namespace.block, scope: .namespace)
    }

    public func visit(sourceFile: TSSourceFile) {
        pushContext()
        context.scope = .topLevel
        write(blockElements: sourceFile.elements)
        printer.writeNewline()
        popContext()
    }

    public func visit(type: TSTypeDecl) {
        write(modifiers: type.modifiers)
        printer.write(space: " ", "type \(type.name)")
        write(genericParams: type.genericParams)
        printer.write(" = ")
        visit(type.type)
        printer.write(";")
    }

    public func visit(`var`: TSVarDecl) {
        write(modifiers: `var`.modifiers)
        printer.write(space: " ", "\(`var`.kind) \(`var`.name)")
        if let type = `var`.type {
            printer.write(": ")
            visit(type)
        }
        if let initializer = `var`.initializer {
            printer.write(space: " ", "= ")
            visit(initializer)
        }
        printer.write(";")
    }

    public func visit(ident: TSIdentExpr) {
        printer.write(ident.name)
    }

    public func visit(numberLiteral: TSNumberLiteralExpr) {
        printer.write(numberLiteral.text)
    }

    private func write(block: TSBlockStmt, scope: ScopeKind? = nil) {
        pushContext()
        if let scope {
            context.scope = scope
        }
        visit(block)
        popContext()
    }

    public func visit(block: TSBlockStmt) {
        openBracket("{")
        write(blockElements: block.elements)
        closeBracket("}")
    }

    public func visit(forIn: TSForInStmt) {
        printer.write("for (\(forIn.kind) \(forIn.name) \(forIn.operator) ")
        visit(forIn.expr)
        printer.write(") ")
        visit(forIn.body)
    }

    public func visit(if: TSIfStmt) {
        printer.write("if (")
        visit(`if`.condition)
        printer.write(") ")
        visit(`if`.then)
        if let `else` = `if`.else {
            if !(`if`.then is TSBlockStmt) {
                printer.writeNewline()
            }

            printer.write(space: " ", "else ")
            visit(`else`)
        }
    }

    public func visit(return: TSReturnStmt) {
        printer.write("return ")
        visit(`return`.expr)
        printer.write(";")
    }

    public func visit(throw: TSThrowStmt) {
        printer.write("throw ")
        visit(`throw`.expr)
        printer.write(";")
    }

    public func visit(array: TSArrayType) {
        let paren: Bool = {
            switch array.element {
            case is TSUnionType: return true
            default: return false
            }
        }()

        if paren {
            openBracket("(")
        }
        visit(array.element)
        if paren {
            closeBracket(")")
        }
        printer.write("[]")
    }

    public func visit(custom: TSCustomType) {
        printer.write(custom.text)
    }

    public func visit(dictionary: TSDictionaryType) {
        printer.write("{ [key: string]: ")
        visit(dictionary.value)
        printer.write("; }")
    }

    public func visit(function: TSFunctionType) {
        write(params: function.params)
        printer.write(" => ")
        visit(function.result)
    }

    private func write(params: [TSFunctionType.Param]) {
        openBracket("(")
        write(array: params, separator: ",") {
            write(param: $0)
        }
        closeBracket(")")
    }

    private func write(param: TSFunctionType.Param) {
        printer.write(param.name)
        if let type = param.type {
            printer.write(": ")
            visit(type)
        }
    }

    public func visit(ident: TSIdentType) {
        printer.write(ident.name)
        write(genericArgs: ident.genericArgs)
    }

    public func visit(member: TSMemberType) {
        visit(member.base)
        printer.write(".")
        visit(member.name)
    }

    public func visit(record: TSRecordType) {
        openBracket("{")
        write(array: record.fields, multilineMode: .multiline) {
            write(field: $0)
        }
        closeBracket("}")
    }

    private func write(field: TSRecordType.Field) {
        printer.write(field.name)
        if field.isOptional {
            printer.write("?: ")
        } else {
            printer.write(": ")
        }
        visit(field.type)
        printer.write(";")
    }

    public func visit(stringLiteral: TSStringLiteralType) {
        printer.write("\"")
        printer.write(stringLiteral.value)
        printer.write("\"")
    }

    public func visit(union: TSUnionType) {
        write(array: union.elements, separator: " |") {
            visit($0)
        }
    }
}
