extension ASTNode {
    public var declaredName: String? {
        switch self {
        case let x as TSClassDecl: return x.name
        case let x as TSFunctionDecl: return x.name
        case let x as TSInterfaceDecl: return x.name
        case let x as TSNamespaceDecl: return x.name
        case let x as TSTypeDecl: return x.name
        case let x as TSVarDecl: return x.name
        default: return nil
        }
    }
}


extension TSBlockStmt {
    public var memberDeclaredNames: [String] {
        return elements.compactMap { $0.declaredName }
    }
}

extension TSCaseStmt {
    public var memberDeclaredNames: [String] {
        return elements.compactMap { $0.declaredName }
    }
}

extension TSDefaultStmt {
    public var memberDeclaredNames: [String] {
        return elements.compactMap { $0.declaredName }
    }
}

extension TSSourceFile {
    public var memberDeclaredNames: [String] {
        return elements.compactMap { $0.declaredName }
    }
}


