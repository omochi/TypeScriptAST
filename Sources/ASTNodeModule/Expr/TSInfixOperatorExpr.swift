public final class TSInfixOperatorExpr: _TSExpr {
    public init(
        _ lhs: any TSExpr,
        _ `operator`: String,
        _ rhs: any TSExpr
    ) {
        self.operator = `operator`
        self.lhs = lhs
        self.rhs = rhs
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var lhs: any TSExpr
    public var `operator`: String
    @AnyTSExprStorage public var rhs: any TSExpr
}
