public final class TSImportDecl: _TSDecl {
    public init(names: [String], from: String) {
        self.names = names
        self.from = from
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var names: [String]
    public var from: String
}
