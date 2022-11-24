public final class TSIdentExpr: _TSExpr {
    public init(_ name: String) {
        self.name = name
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    public var name: String
}
