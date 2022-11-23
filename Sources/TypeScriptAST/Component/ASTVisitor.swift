public protocol ASTVisitor {
    func visit(_ node: any ASTNode)

    func visit(decl: any TSDecl)
    func visit(functionDecl: TSFunctionDecl)
    func visit(importDecl: TSImportDecl)
    func visit(namespaceDecl: TSNamespaceDecl)
    func visit(typeDecl: TSTypeDecl)
    func visit(varDecl: TSVarDecl)

    func visit(type: any TSType)
    func visit(arrayType: TSArrayType)
    func visit(customType: TSCustomType)
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
        case let x as TSFunctionDecl:
            visit(functionDecl: x)
        case let x as TSImportDecl:
            visit(importDecl: x)
        case let x as TSNamespaceDecl:
            visit(namespaceDecl: x)
        case let x as TSTypeDecl:
            visit(typeDecl: x)
        case let x as TSVarDecl:
            visit(varDecl: x)
        case let x as TSArrayType:
            visit(arrayType: x)
        case let x as TSCustomType:
            visit(customType: x)
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

    public func visit(decl: any TSDecl) {}
    public func visit(functionDecl: TSFunctionDecl) { visit(decl: functionDecl) }
    public func visit(importDecl: TSImportDecl) { visit(decl: importDecl) }
    public func visit(namespaceDecl: TSNamespaceDecl) { visit(decl: namespaceDecl) }
    public func visit(typeDecl: TSTypeDecl) { visit(decl: typeDecl) }
    public func visit(varDecl: TSVarDecl) { visit(decl: varDecl) }

    public func visit(type: any TSType) {}
    public func visit(arrayType: TSArrayType) { visit(type: arrayType) }
    public func visit(customType: TSCustomType) { visit(type: customType) }
    public func visit(dictionaryType: TSDictionaryType) { visit(type: dictionaryType) }
    public func visit(functionType: TSFunctionType) { visit(type: functionType) }
    public func visit(namedType: TSNamedType) { visit(type: namedType) }
    public func visit(nestedType: TSNestedType) { visit(type: nestedType) }
    public func visit(recordType: TSRecordType) { visit(type: recordType) }
    public func visit(stringLiteralType: TSStringLiteralType) { visit(type: stringLiteralType) }
    public func visit(unionType: TSUnionType) { visit(type: unionType) }
}
