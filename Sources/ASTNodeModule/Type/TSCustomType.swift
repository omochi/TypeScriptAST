public final class TSCustomType: _TSType {
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
