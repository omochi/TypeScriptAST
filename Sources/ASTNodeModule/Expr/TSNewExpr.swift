public final class TSNewExpr: _TSExpr {
    public init(
        callee: TSIdentType,
        args: [any TSExpr]
    ) {
        self.callee = callee
        self.args = args
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @ASTNodeStorage public var callee: TSIdentType
    @AnyTSExprArrayStorage public var args: [any TSExpr]
}
