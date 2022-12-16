public final class TSMemberType: _TSType {
    public init(
        base: any TSType,
        name: String,
        genericArgs: [any TSType]
    ) {
        self.name = name
        self.base = base
        self.genericArgs = genericArgs
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSTypeStorage public var base: any TSType
    public var name: String
    @AnyTSTypeArrayStorage public var genericArgs: [any TSType]
}
