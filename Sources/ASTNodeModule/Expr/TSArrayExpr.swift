public final class TSArrayExpr: _TSExpr {
    public init(
        _ elements: [any TSExpr]
    ) {
        self.elements = elements
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    @AnyTSExprArrayStorage public var elements: [any TSExpr]
}
