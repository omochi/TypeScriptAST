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

    private func wantsNewlineBetweenSiblingDecl(decl: any TSDecl) -> Bool {
        switch decl {
//        case .class:
//            return true
//        case .field:
//            return false
        case is TSImportDecl:
            return false
//        case .interface:
//            return true
            // method
        case is TSFunctionDecl:
//        case is TSMethodDecl:
            switch context.scope {
            case .interface:
                return false
            default:
                return true
            }
        case is TSNamespaceDecl:
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
//        case .custom:
//            return true
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
            if index > 0,
               let prevDecl = elements[index - 1].asDecl,
               let decl = element.asDecl
            {
                let isSame = type(of: prevDecl) == type(of: decl)
                if !isSame || wantsNewlineBetweenSiblingDecl(decl: decl) {
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

    public func visit(importDecl: TSImportDecl) {
        printer.write("import ")
        openBracket("{")
        write(array: importDecl.names, sideSpace: true, separator: ",") {
            printer.write($0)
        }
        closeBracket("}")
        printer.write(" from \"\(importDecl.from)\";", newline: true)
    }

    public func visit(namespaceDecl: TSNamespaceDecl) {
        write(modifiers: namespaceDecl.modifiers)
        printer.write(space: " ", "namespace \(namespaceDecl.name)")
        openBracket(scope: .namespace, space: " ", "{")
        write(blockElements: namespaceDecl.decls)
        closeBracket("}")
    }

    public func visit(typeDecl: TSTypeDecl) {
        write(modifiers: typeDecl.modifiers)
        printer.write(space: " ", "type \(typeDecl.name)")
        write(genericParams: typeDecl.genericParams)
        printer.write(" = ")
        visit(typeDecl.type)
        printer.write(";")
    }

    public func visit(arrayType: TSArrayType) {
        let paren: Bool = {
            switch arrayType.element {
            case is TSUnionType: return true
            default: return false
            }
        }()

        if paren {
            openBracket("(")
        }
        visit(arrayType.element)
        if paren {
            closeBracket(")")
        }
        printer.write("[]")
    }

    public func visit(customType: TSCustomType) {
        printer.write(customType.text)
    }

    public func visit(dictionaryType: TSDictionaryType) {
        printer.write("{ [key: string]: ")
        visit(dictionaryType.value)
        printer.write("; }")
    }

    public func visit(functionType: TSFunctionType) {
        write(params: functionType.params)
        printer.write(" => ")
        visit(functionType.result)
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

    public func visit(namedType: TSNamedType) {
        printer.write(namedType.name)
        write(genericArgs: namedType.genericArgs)
    }

    public func visit(nestedType: TSNestedType) {
        printer.write(nestedType.namespace)
        printer.write(".")
        visit(nestedType.type)
    }

    public func visit(recordType: TSRecordType) {
        openBracket("{")
        write(array: recordType.fields, multilineMode: .multiline) {
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

    public func visit(stringLiteralType: TSStringLiteralType) {
        printer.write("\"")
        printer.write(stringLiteralType.value)
        printer.write("\"")
    }

    public func visit(unionType: TSUnionType) {
        write(array: unionType.elements, separator: " |") {
            visit($0)
        }
    }
}
