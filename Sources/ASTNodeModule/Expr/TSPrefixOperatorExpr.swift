public final class TSPrefixOperatorExpr: _TSExpr {
    public init(
        _ `operator`: String,
        _ expr: any TSExpr
    ) {
        self.operator = `operator`
        self.expr = expr
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var `operator`: String
    @AnyTSExprStorage public var expr: any TSExpr
}
