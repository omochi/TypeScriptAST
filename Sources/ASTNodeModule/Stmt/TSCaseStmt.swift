public final class TSCaseStmt: _TSStmt {
    public init(
        expr: any TSExpr,
        elements: [any ASTNode]
    ) {
        self.expr = expr
        self.elements = elements
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var expr: any TSExpr
    @AnyASTNodeArrayStorage public var elements: [any ASTNode]
}
