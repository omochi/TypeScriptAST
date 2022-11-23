public final class TSNamespaceDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        decls: [TSDecl]
    ) {
        self.modifiers = modifiers
        self.name = name
        self.decls = decls
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var name: String
    @AnyTSDeclArrayStorage public var decls: [any TSDecl]
}
