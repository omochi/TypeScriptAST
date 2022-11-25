public final class TSParenExpr: _TSExpr {
    public init(
        _ expr: any TSExpr
    ) {
        self.expr = expr
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var expr: any TSExpr
}
