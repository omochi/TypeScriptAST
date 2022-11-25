public final class TSFieldDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        isOptional: Bool = false,
        type: any TSType
    ) {
        self.modifiers = modifiers
        self.name = name
        self.isOptional = isOptional
        self.type = type
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var name: String
    public var isOptional: Bool
    @AnyTSTypeStorage public var type: any TSType
}
