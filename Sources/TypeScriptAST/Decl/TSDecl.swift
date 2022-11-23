public protocol TSDecl: ASTNode {
    var modifiers: [TSDeclModifier] { get }
}

internal protocol _TSDecl: _ASTNode & TSDecl {}

extension TSDecl {
    public var asFunction: TSFunctionDecl? { self as? TSFunctionDecl }
    public var asImport: TSImportDecl? { self as? TSImportDecl }
    public var asNamespace: TSNamespaceDecl? { self as? TSNamespaceDecl }
    public var asType: TSTypeDecl? { self as? TSTypeDecl }
    public var asVar: TSVarDecl? { self as? TSVarDecl }
}
