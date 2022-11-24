public final class TSPrefixOperatorExpr: _TSExpr {
    public init(
        _ `operator`: String,
        _ expr: any TSExpr
    ) {
        self.operator = `operator`
        self.expr = expr
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    public var `operator`: String
    @AnyTSExprStorage public var expr: any TSExpr

    public static func await(_ expr: any TSExpr) -> TSPrefixOperatorExpr { TSPrefixOperatorExpr("await", expr) }
}
