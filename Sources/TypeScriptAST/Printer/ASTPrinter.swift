import Foundation

extension ASTNode {
    public func print() -> String {
        let printer = ASTPrinter()
        return printer.print(self)
    }
}

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
        self.initialContext = Context(
            scope: scope,
            isInBrackets: false
        )
        super.init()
    }

    private let initialContext: Context
    private var printer: PrettyPrinter!
    public var onelineCount: Int = 3

    private var contextStack: [Context] = []
    private var context: Context {
        get { contextStack.last! }
        set {
            contextStack[contextStack.count - 1] = newValue
        }
    }
    private func push() {
        contextStack.append(context)
    }
    private func pop() {
        contextStack.removeLast()
    }

    private func closeBracket(for open: String) -> String {
        switch open {
        case "(": return ")"
        case "{": return "}"
        case "[": return "]"
        case "<": return ">"
        default: return open
        }
    }

    private func escape(_ string: String) -> String {
        let b = "\\"
        let q = "\""
        let n = "\n"
        var s = string
        s = s.replacingOccurrences(of: "\(b)", with: "\(b)\(b)")
        s = s.replacingOccurrences(of: "\(q)", with: "\(b)\(q)")
        s = s.replacingOccurrences(of: "\(n)", with: "\(b)n")
        return s
    }

    private func isValidIdentifier(_ name: String) -> Bool {
        let scalars = name.unicodeScalars
        guard let start = scalars.first,
              (start.properties.isIDStart || start == "_" || start == "$") else {
            return false
        }
        let i = scalars.index(after: scalars.startIndex)
        return scalars[i...].allSatisfy { scaler in
            scaler.properties.isIDContinue
            || scaler == "$"
            || scaler == "\u{200D}"
            || scaler == "\u{200C}"
        }
    }

    private func nest<R>(
        scope: ScopeKind? = nil,
        bracket: String? = nil,
        _ body: () throws -> R
    ) rethrows -> R {
        push()

        if let scope {
            context.scope = scope
        }
        if let bracket {
            printer.write(bracket)
            context.isInBrackets = true
        }

        defer {
            if let bracket {
                printer.write(closeBracket(for: bracket))
                context.isInBrackets = false
            }

            pop()
        }
        return try body()
    }

    public func print(_ node: any ASTNode) -> String {
        self.printer = PrettyPrinter()
        self.contextStack = [initialContext]
        walk(node)
        return printer.output
    }

    private func printsNewlineBetween(
        prev: any ASTNode,
        next: any ASTNode
    ) -> Bool {
        guard let prev = prev.asDecl,
              let next = next.asDecl else
        {
            return false
        }

        if type(of: prev) != type(of: next) {
            return true
        }

        switch next {
        case is TSClassDecl:
            return true
        case is TSFieldDecl:
            return false
        case is TSImportDecl:
            return false
        case is TSIndexDecl:
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
        startSpace: String? = nil,
        endSpace: String? = nil,
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

        printer.nestIf(
            condition: isMultiline && context.isInBrackets
        ) {
            for (index, element) in array.enumerated() {
                if index == 0, let startSpace, !isMultiline {
                    printer.write(space: startSpace)
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
                    if let endSpace, !isMultiline {
                        printer.write(space: endSpace)
                    }
                }
            }
        }
    }

    private func write(blockElements elements: [any ASTNode]) {
        if elements.isEmpty { return }

        printer.nestIf(
            condition: context.isInBrackets
        ) {
            for (index, element) in elements.enumerated() {
                if index > 0 {
                    if printsNewlineBetween(prev: elements[index - 1], next: element) {
                        printer.writeNewline()
                    }
                }

                walk(element)
                if element is any TSExpr {
                    printer.write(";")
                }

                if index < elements.count - 1 {
                    printer.writeNewline()
                }
            }
        }
    }

    private func write(modifiers: [TSDeclModifier]) {
        write(array: modifiers, multilineMode: .oneline) {
            printer.write($0.rawValue)
        }
    }

    private func write(genericArgs: [any TSType]) {
        if genericArgs.isEmpty { return }
        nest(bracket: "<") {
            write(array: genericArgs, separator: ",") {
                walk($0)
            }
        }
    }

    private func write(genericParams: [TSTypeParameterNode]) {
        if genericParams.isEmpty { return }
        nest(bracket: "<") {
            write(array: genericParams, separator: ",") {
                walk($0)
            }
        }
    }

    // MARK: - node

    public override func visit(typeParameter: TSTypeParameterNode) -> Bool {
        printer.write(typeParameter.name)
        if let constraint = typeParameter.constraint {
            printer.write(" extends ")
            walk(constraint)
        }
        if let `default` = typeParameter.default {
            printer.write(" = ")
            walk(`default`)
        }
        return false
    }

    // MARK: - decl

    public override func visit(class: TSClassDecl) -> Bool {
        write(modifiers: `class`.modifiers)
        printer.write(space: " ", "class \(`class`.name)")
        write(genericParams: `class`.genericParams)
        if let extends = `class`.extends {
            printer.write(" extends ")
            walk(extends)
        }
        if !`class`.implements.isEmpty {
            printer.write(" implements")
            nest(bracket: "") {
                write(array: `class`.implements, startSpace: " ", separator: ",") {
                    walk($0)
                }
            }
        }
        printer.write(space: " ")
        write(block: `class`.body, scope: .class)
        return false
    }

    public override func visit(field: TSFieldDecl) -> Bool {
        write(modifiers: field.modifiers)
        printer.write(space: " ", field.name)
        if field.isOptional {
            printer.write("?: ")
        } else {
            printer.write(": ")
        }
        walk(field.type)
        printer.write(";")
        return false
    }

    public override func visit(function: TSFunctionDecl) -> Bool {
        write(modifiers: function.modifiers)
        printer.write(space: " ", "function \(function.name)")
        write(genericParams: function.genericParams)
        write(params: function.params)
        if let result = function.result {
            printer.write(": ")
            walk(result)
        }
        printer.write(space: " ")
        write(block: function.body, scope: .function)
        return false
    }

    public override func visit(interface: TSInterfaceDecl) -> Bool {
        write(modifiers: interface.modifiers)
        printer.write(space: " ", "interface \(interface.name)")
        write(genericParams: interface.genericParams)
        if !interface.extends.isEmpty {
            printer.write(" extends")
            write(array: interface.extends, startSpace: " ", separator: ",") {
                walk($0)
            }
        }
        printer.write(space: " ")
        write(block: interface.body, scope: .interface)
        return false
    }

    public override func visit(import: TSImportDecl) -> Bool {
        printer.write("import ")
        nest(bracket: "{") {
            write(
                array: `import`.names,
                startSpace: " ", endSpace: " ",
                separator: ","
            ) {
                printer.write($0)
            }
        }
        printer.write(" from \"\(`import`.from)\";")
        return false
    }

    public override func visit(index: TSIndexDecl) -> Bool {
        write(modifiers: index.modifiers)
        printer.write(space: " ", "[")
        printer.write(index.name)
        printer.write(": ")
        walk(index.index)
        printer.write("]")
        printer.write(": ")
        walk(index.value)
        printer.write(";")
        return false
    }

    public override func visit(method: TSMethodDecl) -> Bool {
        write(modifiers: method.modifiers)
        printer.write(space: " ")
        if isValidIdentifier(method.name) {
            printer.write(method.name)
        } else {
            printer.write("\"")
            printer.write(escape(method.name))
            printer.write("\"")
        }
        if method.isOptional {
            printer.write("?")
        }
        write(genericParams: method.genericParams)
        write(params: method.params)
        if let result = method.result {
            printer.write(": ")
            walk(result)
        }
        if let block = method.body {
            printer.write(space: " ")
            write(block: block)
        } else {
            printer.write(";")
        }
        return false
    }

    public override func visit(namespace: TSNamespaceDecl) -> Bool {
        write(modifiers: namespace.modifiers)
        printer.write(space: " ", "namespace \(namespace.name) ")
        write(block: namespace.body, scope: .namespace)
        return false
    }

    public override func visit(sourceFile: TSSourceFile) -> Bool {
        nest(scope: .topLevel) {
            write(blockElements: sourceFile.elements)
            printer.writeNewline()
        }
        return false
    }

    public override func visit(type: TSTypeDecl) -> Bool {
        write(modifiers: type.modifiers)
        printer.write(space: " ", "type \(type.name)")
        write(genericParams: type.genericParams)
        printer.write(" = ")
        walk(type.type)
        printer.write(";")
        return false
    }

    public override func visit(`var`: TSVarDecl) -> Bool {
        write(modifiers: `var`.modifiers)
        printer.write(space: " ", "\(`var`.kind) \(`var`.name)")
        if let type = `var`.type {
            printer.write(": ")
            walk(type)
        }
        if let initializer = `var`.initializer {
            printer.write(space: " ", "= ")
            walk(initializer)
        }
        printer.write(";")
        return false
    }

    // MARK: - expr

    public override func visit(array: TSArrayExpr) -> Bool {
        nest(bracket: "[") {
            write(array: array.elements, separator: ",") {
                walk($0)
            }
        }
        return false
    }

    public override func visit(as: TSAsExpr) -> Bool {
        walk(`as`.expr)
        printer.write(" as ")
        walk(`as`.type)
        return false
    }

    public override func visit(assign: TSAssignExpr) -> Bool {
        walk(assign.lhs)
        printer.write(" = ")
        walk(assign.rhs)
        return false
    }

    public override func visit(await: TSAwaitExpr) -> Bool {
        printer.write("await ")
        walk(`await`.expr)
        return false
    }

    public override func visit(call: TSCallExpr) -> Bool {
        walk(call.callee)
        write(args: call.args)
        return false
    }

    public override func visit(closure: TSClosureExpr) -> Bool {
        switch closure.genericParams.count {
        case 1:
            nest(bracket: "<") {
                walk(closure.genericParams[0])
                printer.write(",")
            }
        default:
            write(genericParams: closure.genericParams)
        }
        write(params: closure.params, paren: closure.hasParen)
        if let result = closure.result {
            printer.write(": ")
            walk(result)
        }
        printer.write(" => ")
        walk(closure.body)
        return false
    }

    public override func visit(custom: TSCustomExpr) -> Bool {
        printer.write(custom.text)
        return false
    }

    private func write(args: [any TSExpr]) {
        nest(bracket: "(") {
            write(array: args, separator: ",") {
                walk($0)
            }
        }
    }

    public override func visit(ident: TSIdentExpr) -> Bool {
        printer.write(ident.name)
        return false
    }

    public override func visit(infixOperator: TSInfixOperatorExpr) -> Bool {
        walk(infixOperator.lhs)
        printer.write(" \(infixOperator.operator) ")
        walk(infixOperator.rhs)
        return false
    }

    public override func visit(member: TSMemberExpr) -> Bool {
        walk(member.base)
        if member.isOptional {
            printer.write("?")
        }
        printer.write(".")
        printer.write(member.name)
        return false
    }

    public override func visit(new: TSNewExpr) -> Bool {
        printer.write("new ")
        walk(new.callee)
        write(args: new.args)
        return false
    }

    public override func visit(nullLiteral: TSNullLiteralExpr) -> Bool {
        printer.write("null")
        return false
    }

    public override func visit(booleanLiteral: TSBooleanLiteralExpr) -> Bool {
        if booleanLiteral.value {
            printer.write("true")
        } else {
            printer.write("false")
        }
        return false
    }

    public override func visit(numberLiteral: TSNumberLiteralExpr) -> Bool {
        printer.write(numberLiteral.text)
        return false
    }

    public override func visit(object: TSObjectExpr) -> Bool {
        nest(bracket: "{") {
            write(array: object.fields, separator: ",", multilineMode: .multiline) {
                write(field: $0)
            }
        }
        return false
    }

    private func write(field: TSObjectExpr.Field) {
        switch field {
        case .named(let name, let value):
            if isValidIdentifier(name) {
                printer.write(name)
            } else {
                printer.write("\"")
                printer.write(escape(name))
                printer.write("\"")
            }
            printer.write(": ")
            walk(value)
        case .shorthandPropertyNames(let value):
            walk(value)
        case .computedPropertyNames(let name, let value):
            printer.write("[")
            walk(name)
            printer.write("]")
            printer.write(": ")
            walk(value)
        case .method(let decl):
            walk(decl)
        case .destructuring(let value):
            printer.write("...")
            walk(value)
        }
    }

    public override func visit(paren: TSParenExpr) -> Bool {
        printer.write("(")
        walk(paren.expr)
        printer.write(")")
        return false
    }

    public override func visit(postfixOperator: TSPostfixOperatorExpr) -> Bool {
        walk(postfixOperator.expr)
        printer.write(space: " ", "\(postfixOperator.operator)")
        return false
    }

    public override func visit(prefixOperator: TSPrefixOperatorExpr) -> Bool {
        printer.write("\(prefixOperator.operator) ")
        walk(prefixOperator.expr)
        return false
    }

    public override func visit(stringLiteral: TSStringLiteralExpr) -> Bool {
        printer.write("\"")
        printer.write(escape(stringLiteral.text))
        printer.write("\"")
        return false
    }

    public override func visit(templateLiteral: TSTemplateLiteralExpr) -> Bool {
        if let tag = templateLiteral.tag {
            printer.write(tag)
        }
        printer.write("`")
        for fragment in templateLiteral.fragments {
            switch fragment {
            case .literal(let literal):
                printer.write(literal)
            case .expr(let expr):
                printer.write("${")
                walk(expr)
                printer.write("}")
            }
        }
        printer.write("`")
        return false
    }

    public override func visit(subscript: TSSubscriptExpr) -> Bool {
        walk(`subscript`.base)
        printer.write("[")
        walk(`subscript`.key)
        printer.write("]")
        return false
    }

    // MARK: - stmt

    private func write(block: TSBlockStmt, scope: ScopeKind? = nil) {
        nest(scope: scope) {
            walk(block)
        }
    }

    public override func visit(block: TSBlockStmt) -> Bool {
        nest(bracket: "{") {
            write(blockElements: block.elements)
        }
        return false
    }

    public override func visit(case: TSCaseStmt) -> Bool {
        printer.write("case ")
        walk(`case`.expr)
        printer.write(":")
        nest(bracket: "") {
            write(blockElements: `case`.elements)
        }
        return false
    }

    public override func visit(catch: TSCatchStmt) -> Bool {
        printer.write("catch")
        if let name = `catch`.name {
            printer.write(space: " ")
            nest(bracket: "(") {
                printer.write(name)
            }
        }
        printer.write(space: " ")
        walk(`catch`.body)
        return false
    }

    public override func visit(default: TSDefaultStmt) -> Bool {
        printer.write("default:")
        nest(bracket: "") {
            write(blockElements: `default`.elements)
        }
        return false
    }

    public override func visit(finally: TSFinallyStmt) -> Bool {
        printer.write("finally ")
        walk(finally.body)
        return false
    }

    public override func visit(forIn: TSForInStmt) -> Bool {
        printer.write("for (\(forIn.kind) \(forIn.name) \(forIn.operator) ")
        walk(forIn.expr)
        printer.write(") ")
        walk(forIn.body)
        return false
    }

    public override func visit(if: TSIfStmt) -> Bool {
        printer.write("if (")
        walk(`if`.condition)
        printer.write(") ")
        walk(`if`.then)
        if let `else` = `if`.else {
            if !(`if`.then is TSBlockStmt) {
                printer.writeNewline()
            }

            printer.write(space: " ", "else ")
            walk(`else`)
        }
        return false
    }

    public override func visit(return: TSReturnStmt) -> Bool {
        printer.write("return")
        if let expr = `return`.expr {
            printer.write(space: " ")
            walk(expr)
        }
        printer.write(";")
        return false
    }

    public override func visit(switch: TSSwitchStmt) -> Bool {
        printer.write("switch (")
        walk(`switch`.expr)
        printer.write(") {")
        for (i, `case`) in `switch`.cases.enumerated() {
            if i == 0 {
                printer.writeNewline()
            }
            walk(`case`)
        }
        printer.write("}")
        return false
    }

    public override func visit(throw: TSThrowStmt) -> Bool {
        printer.write("throw ")
        walk(`throw`.expr)
        printer.write(";")
        return false
    }

    public override func visit(try: TSTryStmt) -> Bool {
        printer.write("try ")
        walk(`try`.body)
        if let `catch` = `try`.catch {
            printer.write(space: " ")
            walk(`catch`)
        }
        if let finally = `try`.finally {
            printer.write(space: " ")
            walk(finally)
        }
        return false
    }

    // MARK: - type

    public override func visit(array: TSArrayType) -> Bool {
        let paren: Bool = {
            switch array.element {
            case is TSUnionType: return true
            case is TSIntersectionType: return true
            case is TSConditionalType: return true
            case is TSInferType: return true
            case is TSKeyofType: return true
            default: return false
            }
        }()

        nest(bracket: paren ? "(" : nil) {
            walk(array.element)
        }
        printer.write("[]")
        return false
    }

    public override func visit(conditional: TSConditionalType) -> Bool {
        walk(conditional.check)
        printer.write(" extends ")
        walk(conditional.extends)

        printer.nest {
            printer.write("? ")
            walk(conditional.true)
            printer.writeNewline()
            printer.write(": ")
            walk(conditional.false)
        }
        return false
    }

    public override func visit(custom: TSCustomType) -> Bool {
        printer.write(custom.text)
        return false
    }

    public override func visit(function: TSFunctionType) -> Bool {
        write(genericParams: function.genericParams)
        write(params: function.params)
        printer.write(" => ")
        walk(function.result)
        return false
    }

    private func write(params: [TSFunctionType.Param], paren: Bool = true) {
        nest(bracket: paren ? "(" : nil) {
            write(array: params, separator: ",") {
                write(param: $0)
            }
        }
    }

    private func write(param: TSFunctionType.Param) {
        if param.spread {
            printer.write("...")
        }
        printer.write(param.name)
        if let type = param.type {
            if param.isOptional {
                printer.write("?: ")
            } else {
                printer.write(": ")
            }
            walk(type)
        }
    }

    public override func visit(ident: TSIdentType) -> Bool {
        printer.write(ident.name)
        write(genericArgs: ident.genericArgs)
        return false
    }

    public override func visit(indexedAccess: TSIndexedAccessType) -> Bool {
        walk(indexedAccess.base)
        printer.write("[")
        walk(indexedAccess.index)
        printer.write("]")
        return false
    }

    public override func visit(infer: TSInferType) -> Bool {
        printer.write("infer ")
        printer.write(infer.name)
        return false
    }

    public override func visit(intersection: TSIntersectionType) -> Bool {
        func needsParen(_ type: any TSType) -> Bool {
            switch type {
            case is TSUnionType: return true
            case is TSIntersectionType: return true
            case is TSConditionalType: return true
            case is TSInferType: return true
            case is TSKeyofType: return true
            default: return false
            }
        }

        write(array: intersection.elements, separator: " &") { (type) in
            nest(bracket: needsParen(type) ? "(" : nil) {
                walk(type)
            }
        }
        return false
    }

    public override func visit(keyof: TSKeyofType) -> Bool {
        printer.write("keyof ")
        walk(keyof.type)
        return false
    }

    public override func visit(mapped: TSMappedType) -> Bool {
        nest(bracket: "{") {
            printer.push(newline: true)
            if let readonly = mapped.readonly {
                if readonly == .remove {
                    printer.write("-")
                }
                printer.write("readonly")
            }
            printer.write(space: " ", "[")
            printer.write(mapped.name)
            printer.write(" in ")
            walk(mapped.constraint)
            if let name = mapped.nameType {
                printer.write(space: " ", "as ")
                walk(name)
            }
            printer.write("]")
            if let optional = mapped.optional {
                if optional == .remove {
                    printer.write("-")
                }
                printer.write("?")
            }
            printer.write(": ")
            walk(mapped.value)
            printer.write(";")
            printer.pop()
        }
        return false
    }

    public override func visit(member: TSMemberType) -> Bool {
        walk(member.base)
        printer.write(".")
        printer.write(member.name)
        write(genericArgs: member.genericArgs)
        return false
    }

    public override func visit(numberLiteral: TSNumberLiteralType) -> Bool {
        printer.write(numberLiteral.text)
        return false
    }

    public override func visit(object: TSObjectType) -> Bool {
        nest(bracket: "{") {
            write(array: object.fields, multilineMode: .multiline) {
                write(field: $0)
            }
        }
        return false
    }

    private func write(field: TSObjectType.Field) {
        switch field {
        case .field(let decl):
            walk(decl)
        case .method(let decl):
            walk(decl)
        case .index(let decl):
            walk(decl)
        }
    }

    public override func visit(stringLiteral: TSStringLiteralType) -> Bool {
        printer.write("\"")
        printer.write(escape(stringLiteral.value))
        printer.write("\"")
        return false
    }

    public override func visit(tuple: TSTupleType) -> Bool {
        nest(bracket: "[") {
            write(array: tuple.elements, separator: ",") {
                walk($0)
            }
        }
        return false
    }

    public override func visit(union: TSUnionType) -> Bool {
        write(array: union.elements, separator: " |") {
            walk($0)
        }
        return false
    }
}
