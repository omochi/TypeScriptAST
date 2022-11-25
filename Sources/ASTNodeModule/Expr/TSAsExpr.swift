public final class TSAsExpr: _TSExpr {
    public init(
        _ expr: any TSExpr,
        _ type: any TSType
    ) {
        self.expr = expr
        self.type = type
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprStorage public var expr: any TSExpr
    @AnyTSTypeStorage public var type: any TSType
}
