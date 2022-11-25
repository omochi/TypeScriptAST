public final class TSStringLiteralType: _TSType {
    public init(_ value: String) {
        self.value = value
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var value: String
}
