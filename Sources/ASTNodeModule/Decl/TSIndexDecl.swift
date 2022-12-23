public final class TSIndexDecl: _TSDecl {
    public init(
        modifiers: [TSDeclModifier] = [],
        name: String,
        index: any TSType,
        value: any TSType
    ) {
        self.modifiers = modifiers
        self.name = name
        self.index = index
        self.value = value
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier]
    public var name: String
    @AnyTSTypeStorage public var index: any TSType
    @AnyTSTypeStorage public var value: any TSType
}
