public final class TSStringLiteralType: _TSType {
    public init(_ value: String) {
        self.value = value
    }

    public internal(set) unowned var parent: (any ASTNode)?
    func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var value: String
}
