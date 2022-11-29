public final class TSReturnStmt: _TSStmt {
    public init(_ expr: TSExpr? = nil) {
        self.expr = expr
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprOptionalStorage public var expr: (any TSExpr)?
}
