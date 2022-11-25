public final class TSIfStmt: _TSStmt {
    public init(
        condition: TSExpr,
        then: TSStmt,
        `else`: TSStmt? = nil
    ) {
        self.condition = condition
        self.then = then
        self.else = `else`
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var condition: any TSExpr
    @AnyTSStmtStorage public var then: (any TSStmt)
    @AnyTSStmtOptionalStorage public var `else`: (any TSStmt)?
}
