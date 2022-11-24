public final class TSCallExpr: _TSExpr {
    public init(
        callee: any TSExpr,
        args: [any TSExpr]
    ) {
        self.callee = callee
        self.args = args
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var callee: any TSExpr
    @AnyTSExprArrayStorage public var args: [any TSExpr]
}
