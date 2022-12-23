public final class TSClassDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        genericParams: [TSTypeParameterNode] = [],
        extends: TSIdentType? = nil,
        implements: [TSIdentType] = [],
        body: TSBlockStmt
    ) {
        self.modifiers = modifiers
        self.name = name
        self.genericParams = genericParams
        self.extends = extends
        self.implements = implements
        self.body = body
    }
    
    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var name: String
    public var genericParams: [TSTypeParameterNode]
    @ASTNodeOptionalStorage public var extends: TSIdentType?
    @ASTNodeArrayStorage public var implements: [TSIdentType]
    @ASTNodeStorage public var body: TSBlockStmt
}
