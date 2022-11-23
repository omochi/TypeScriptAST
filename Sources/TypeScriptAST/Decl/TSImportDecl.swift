public final class TSImportDecl: _TSDecl {
    public init(names: [String], from: String) {
        self.names = names
        self.from = from
    }

    public private(set) unowned var parent: ASTNode?
    internal func _setParent(_ newValue: (ASTNode)?) {
        parent = newValue
    }

    public var modifiers: [TSDeclModifier] { [] }
    public var names: [String]
    public var from: String
}
