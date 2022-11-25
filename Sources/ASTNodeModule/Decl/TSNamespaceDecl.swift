public final class TSNamespaceDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        body: TSBlockStmt
    ) {
        self.modifiers = modifiers
        self.name = name
        self.body = body
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var name: String
    @ASTNodeStorage public var body: TSBlockStmt
}
