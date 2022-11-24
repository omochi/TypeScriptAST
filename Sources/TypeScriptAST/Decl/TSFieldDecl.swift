public final class TSFieldDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        type: any TSType,
        isOptional: Bool = false
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
    @AnyTSTypeStorage public var type: any TSType
    public var isOptional: Bool
}
