public final class TSMemberType: _TSType {
    public init(
        base: any TSType,
        name: TSIdentType
    ) {
        self.base = base
        self.name = name
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSTypeStorage public var base: any TSType
    @ASTNodeStorage public var name: TSIdentType
}
