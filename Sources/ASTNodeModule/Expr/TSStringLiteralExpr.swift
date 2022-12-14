public final class TSStringLiteralExpr: _TSExpr {
    public init(_ text: String) {
        self.text = text
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var text: String
}
