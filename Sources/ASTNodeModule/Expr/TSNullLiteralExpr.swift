public final class TSNullLiteralExpr: _TSExpr {
    public init() {
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }
}
