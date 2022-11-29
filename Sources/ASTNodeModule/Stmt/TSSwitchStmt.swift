public final class TSSwitchStmt: _TSStmt {
    public init(
        expr: any TSExpr,
        cases: [any TSStmt] = []
    ) {
        self.expr = expr
        self.cases = cases
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var expr: any TSExpr
    @AnyTSStmtArrayStorage public var cases: [any TSStmt]
}
