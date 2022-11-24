public final class TSCustomExpr: _TSExpr {
    public init(text: String, symbols: [String] = []) {
        self.text = text
        self.symbols = symbols
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var text: String
    public var symbols: [String]
}
