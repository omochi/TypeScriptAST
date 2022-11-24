public final class TSThrowStmt: _TSStmt {
    public init(_ expr: TSExpr) {
        self.expr = expr
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var expr: TSExpr
}
