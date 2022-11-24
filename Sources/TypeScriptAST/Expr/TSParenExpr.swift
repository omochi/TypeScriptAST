public final class TSParenExpr: _TSExpr {
    public init(
        _ expr: any TSExpr
    ) {
        self.expr = expr
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var expr: any TSExpr
}
