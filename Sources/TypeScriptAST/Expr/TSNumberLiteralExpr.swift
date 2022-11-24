public final class TSNumberLiteralExpr: _TSExpr {
    public init(_ text: String) {
        self.text = text
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    public var text: String
}
