public final class TSCustomDecl: _TSDecl {
    public init(text: String, dependencies: [String] = []) {
        self.text = text
        self.dependencies = dependencies
    }

    public private(set) unowned var parent: (any ASTNode)?
    internal func _setParent(_ newValue: (any ASTNode)?) {
        parent = newValue
    }

    public var text: String
    public var dependencies: [String]
}
