public final class TSMemberExpr: _TSExpr {
    public init(
        base: any TSExpr,
        name: String
    ) {
        self.name = name
        self.base = base
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var base: any TSExpr
    public var name: String
}
