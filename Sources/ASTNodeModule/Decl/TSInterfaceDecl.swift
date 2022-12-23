public final class TSInterfaceDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        genericParams: [TSTypeParameterNode] = [],
        extends: [TSIdentType] = [],
        body: TSBlockStmt
    ) {
        self.modifiers = modifiers
        self.name = name
        self.genericParams = genericParams
        self.extends = extends
        self.body = body
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var name: String
    @ASTNodeArrayStorage public var genericParams: [TSTypeParameterNode]
    @ASTNodeArrayStorage public var extends: [TSIdentType]
    @ASTNodeStorage public var body: TSBlockStmt
}
