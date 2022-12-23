public final class TSTypeDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        genericParams: [TSTypeParameterNode] = [],
        type: any TSType
    ) {
        self.modifiers = modifiers
        self.name = name
        self.genericParams = genericParams
        self.type = type
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var name: String
    @ASTNodeArrayStorage public var genericParams: [TSTypeParameterNode]
    @AnyTSTypeStorage public var type: any TSType
}
