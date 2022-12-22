public final class TSNumberLiteralType: _TSType {
    public init(_ text: String) {
        self.text = text
    }

    public convenience init(_ int: Int) {
        self.init("\(int)")
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var text: String
}
