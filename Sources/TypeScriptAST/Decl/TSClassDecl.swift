public final class TSClassDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        genericParams: [String] = [],
        extends: TSIdentType? = nil,
        implements: [TSIdentType] = [],
        block: TSBlockStmt
    ) {
        self.modifiers = modifiers
        self.name = name
        self.genericParams = genericParams
        self.extends = extends
        self.implements = implements
        self.block = block
    }
    
    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var name: String
    public var genericParams: [String]
    @ASTNodeOptionalStorage public var extends: TSIdentType?
    @ASTNodeArrayStorage public var implements: [TSIdentType]
    @ASTNodeStorage public var block: TSBlockStmt
}
