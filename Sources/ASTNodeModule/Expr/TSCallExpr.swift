public final class TSCallExpr: _TSExpr {
    public init(
        callee: any TSExpr,
        genericArgs: [any TSType] = [],
        args: [any TSExpr]
    ) {
        self.callee = callee
        self.genericArgs = genericArgs
        self.args = args
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var callee: any TSExpr
    @AnyTSTypeArrayStorage public var genericArgs: [any TSType]
    @AnyTSExprArrayStorage public var args: [any TSExpr]
}
