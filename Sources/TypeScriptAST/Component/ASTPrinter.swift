public final class ASTPrinter: ASTVisitor {
    public enum ScopeKind {
        case topLevel
        case function
        case `class`
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

    private func openBracket(_ text: String) {
        pushContext()
        printer.write(text)
        context.isInBrackets = true
    }

    private func closeBracket(_ text: String) {
        printer.write(text)
        context.isInBrackets = false
        popContext()
    }

    private func write<T>(
        array: [T],
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
            if index > 0 {
                printer.write(space: " ")
            }
            writeElement(element)

            if index < array.count - 1 {
                printer.write(separator)
                if isMultiline {
                    printer.writeNewline()
                }
            }
        }

        if isMultiline, context.isInBrackets {
            printer.pop()
        }
    }

    private func write(genericArgs: [any TSType]) {
        if genericArgs.isEmpty { return }

        openBracket("<")
        write(array: genericArgs, separator: ",", multilineMode: .oneline) {
            visit($0)
        }
        closeBracket(">")
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
