public protocol TSDecl: ASTNode {}

internal protocol _TSDecl: _ASTNode & TSDecl {}

extension TSDecl {
    // @codegen(as)
    public var asClass: TSClassDecl? { self as? TSClassDecl }
    public var asCustom: TSCustomDecl? { self as? TSCustomDecl }
    public var asField: TSFieldDecl? { self as? TSFieldDecl }
    public var asFunction: TSFunctionDecl? { self as? TSFunctionDecl }
    public var asImport: TSImportDecl? { self as? TSImportDecl }
    public var asIndex: TSIndexDecl? { self as? TSIndexDecl }
    public var asInterface: TSInterfaceDecl? { self as? TSInterfaceDecl }
    public var asMethod: TSMethodDecl? { self as? TSMethodDecl }
    public var asNamespace: TSNamespaceDecl? { self as? TSNamespaceDecl }
    public var asSourceFile: TSSourceFile? { self as? TSSourceFile }
    public var asType: TSTypeDecl? { self as? TSTypeDecl }
    public var asVar: TSVarDecl? { self as? TSVarDecl }
    // @end
}
