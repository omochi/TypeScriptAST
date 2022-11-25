public final class TSSubscriptExpr: _TSExpr {
    public init(
        base: any TSExpr,
        key: any TSExpr
    ) {
        self.base = base
        self.key = key
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var base: any TSExpr
    @AnyTSExprStorage public var key: any TSExpr
}
