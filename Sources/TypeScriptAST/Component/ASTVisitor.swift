public protocol ASTVisitor {
    func visit(_ node: any ASTNode)

    func visit(type: any TSType)
    func visit(arrayType: TSArrayType)
    func visit(dictionaryType: TSDictionaryType)
    func visit(functionType: TSFunctionType)
    func visit(namedType: TSNamedType)
    func visit(nestedType: TSNestedType)
    func visit(recordType: TSRecordType)
    func visit(stringLiteralType: TSStringLiteralType)
    func visit(unionType: TSUnionType)
}

extension ASTVisitor {
    public func visit(_ node: any ASTNode) {
        switch node {
        case let x as TSArrayType:
            visit(arrayType: x)
        case let x as TSDictionaryType:
            visit(dictionaryType: x)
        case let x as TSFunctionType:
            visit(functionType: x)
        case let x as TSNamedType:
            visit(namedType: x)
        case let x as TSNestedType:
            visit(nestedType: x)
        case let x as TSRecordType:
            visit(recordType: x)
        case let x as TSStringLiteralType:
            visit(stringLiteralType: x)
        case let x as TSUnionType:
            visit(unionType: x)
        default:
            break
        }
    }

    public func visit(type: any TSType) {}

    public func visit(arrayType: TSArrayType) {
        visit(type: arrayType)
    }

    public func visit(dictionaryType: TSDictionaryType) {
        visit(type: dictionaryType)
    }

    public func visit(functionType: TSFunctionType) {
        visit(type: functionType)
    }

    public func visit(namedType: TSNamedType) {
        visit(type: namedType)
    }

    public func visit(nestedType: TSNestedType) {
        visit(type: nestedType)
    }

    public func visit(recordType: TSRecordType) {
        visit(type: recordType)
    }

    public func visit(stringLiteralType: TSStringLiteralType) {
        visit(type: stringLiteralType)
    }

    public func visit(unionType: TSUnionType) {
        visit(type: unionType)
    }
}
