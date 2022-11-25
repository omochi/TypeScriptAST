public final class TSPostfixOperatorExpr: _TSExpr {
    public init(
        _ expr: any TSExpr,
        _ `operator`: String
    ) {
        self.operator = `operator`
        self.expr = expr
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var expr: any TSExpr
    public var `operator`: String
}
