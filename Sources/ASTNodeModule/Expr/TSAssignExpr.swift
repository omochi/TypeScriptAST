public final class TSAssignExpr: _TSExpr {
    public init(
        lhs: any TSExpr,
        rhs: any TSExpr
    ) {
        self.lhs = lhs
        self.rhs = rhs
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var lhs: any TSExpr
    @AnyTSExprStorage public var rhs: any TSExpr
}
